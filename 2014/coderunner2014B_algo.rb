#!/usr/bin/ruby
require 'net/https'
require 'json'
NUM_SKILLS=100
THRESHOLD=4000
TOKEN=''
https=Net::HTTP.new('game.coderunner.jp',443)
https.use_ssl=true
prev_room=-1
https.start{
	loop{
		use_skill=nil
		use_skill_point=0
		request=0
		loop{
			#Retrieve info
			resp=https.get("/info?token="+TOKEN+"&filter=all&style=json")
			if resp.code.to_i!=200
				sleep(0.1)
				redo
			end
			json=JSON.parse(resp.body)

			skills=[*0...NUM_SKILLS]
			if json['you']['room']!=prev_room
				puts 'Switched to room '+json['you']['room'].to_s
				prev_room=json['you']['room']
			end

			#Use every data to find the weak point (not using previous battle though)
			json['history'].each{|e|
				if e['damage']>=THRESHOLD && e['damage']>use_skill_point
					use_skill=e['skill']
					use_skill_point=e['damage']
				end
				skills-=[e['skill']]
			}

			if !use_skill
				if skills.empty?
					puts 'warn: use_skill undefined'
					use_skill=[*0...NUM_SKILLS].sample
				else
					use_skill=skills.sample #first 
				end
			end
			break
		}

		request=0
		loop{
			#Search or strong attack
			resp=https.get("/attack?token="+TOKEN+"&skill="+use_skill.to_s)
			if resp.code.to_i!=200 || resp.body.to_i==-1
				sleep(0.1)
				redo
			end

			#fout.puts s
			#fout.puts resp.body
			#fout.flush
			puts 'Skill:'+use_skill.to_s
			puts resp.body
			break
		}
		sleep(1)
	}
}