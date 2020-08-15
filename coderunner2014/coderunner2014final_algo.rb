#!/usr/bin/ruby
require 'net/https'
require 'json'
TOKEN=''
monsters=JSON.parse(File.read(ENV['HOME']+'/Downloads/monsters/monsters.json'))
https=Net::HTTP.new('game.coderunner.jp',443)
https.use_ssl=true
https.start{
	loop{
		use_monster=nil
		monster_scores=nil
		stones=nil

		loop{
			#Retrieve myinfo
			resp=https.get("/info.json?token="+TOKEN)
			if resp.code.to_i!=200
				sleep(0.1)
				redo
			end
			json=JSON.parse(resp.body)
			#check stones and search for monster
			stones=json['stone']
			break
		}
		loop{
			#Retrieve scorelist
			resp=https.get("/scorelist")
			if resp.code.to_i!=200
				sleep(0.1)
				redo
			end
			monster_scores=resp.body.lines.map(&:to_i)
			break
		}
		#Select monster
		#the scores are varied by class. (Lost reason #1)
		#thresholds must be changed according to the market state.
		#Actually market should be automated too. (Lost reason #2)
		use_monster=monsters.sort_by{|e|-monster_scores[e['id'].to_i]}.find{|e|
			if e['name'].start_with?('Tera') #5
				next if monster_scores[e['id'].to_i]<500000
			elsif e['name'].start_with?('Giga') #4
				next if monster_scores[e['id'].to_i]<300000
			elsif e['name'].start_with?('Mega') #3
				next if monster_scores[e['id'].to_i]<80000
			elsif e['name'].start_with?('Nano') #1
				next if monster_scores[e['id'].to_i]<8000
			else #2
				next if monster_scores[e['id'].to_i]<30000
			end
			e['required'].each_with_index.all?{|_,i|_<=stones[i]}
		}
		if !use_monster
			sleep(1)
			redo
		end
		loop{
			#Summon
			resp=https.get("/summon?token="+TOKEN+"&monster="+use_monster['id'])
			if resp.code.to_i!=200 || resp.body.to_i==-1
				sleep(0.1)
				redo
			end

			puts use_monster.to_s
			puts 'Effective Score: '+monster_scores[use_monster['id'].to_i].to_s
			puts resp.body
			break
		}
		sleep(1)
	}
}