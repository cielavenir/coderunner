#!/usr/bin/ruby
require 'json'
require 'net/https'
TOKEN=''
GOOD_WORKS=[29,36,22,48,4,39,16, 41,45,12,38,10,5,44,17]
https=Net::HTTP.new('game.coderunner.jp',443);https.use_ssl=true
#https=Net::HTTP.new('sample.coderunner.jp',80)
#File.open('runner_algo.txt','ab'){|fout|
cnt=0

def assign(https,task)
	puts '[*] Trying '+task.to_s
	resp=https.get("/assign?task="+task.to_s+"&worker="+[*0..49].join(',')+"&token="+TOKEN)
	puts resp.body
	return resp.code.to_i==200
end

loop{
	puts '[*] Performing...'
	task=nil
	loop{
		resp=https.get("/getoutJson?token="+TOKEN)
		if resp.code.to_i==200
			json=JSON.parse(resp.body)
			task=json['outsources'].find{|e|
				seed=e['reward']/(e['load'].to_f/1250)**2
				p [seed.to_i,e['pattern'],e['reward']]
				e['load'].to_i>=1250 and seed>=75 and GOOD_WORKS.include?(e['pattern'].to_i) and assign(https,e['id'])
			}
			task=task['id'] if task
		end
		if task
			puts '[+] Found outsource: '+task.to_s
			break
		else
			puts '[-] Have to take task.'
		end
		#take task
		loop{
			resp=https.get("/taketaskJson?token="+TOKEN)
			redo if resp.code.to_i!=200
			json=JSON.parse(resp.body)
			#sleep(0.2)
			task=json['id']
			true until assign(https,task)
			break
		}
		break
	}

	loop{
		resp=https.get("/getinfoJson?token="+TOKEN)
		redo if resp.code.to_i!=200
		json=JSON.parse(resp.body)
		time=json['workers'].map{|e|e['time'].to_f}.max
		puts '[#] Wait: '+time.to_s
		sleep(time)
		break
	}
}
#}
__END__
受注->全割当->待機
しかしないことにしました…

外注の受注基準は、「得意な仕事」であり、仕事量が1250以上で、問題文に示される乱数値(を報酬と仕事量から逆算した結果)が75以上であることです。
乱数は80〜120の一様乱数位より生成されますが、外注マージンを考えて75相当なら可ということです。