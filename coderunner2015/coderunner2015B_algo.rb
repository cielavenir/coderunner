#!/usr/bin/ruby
require 'json'
require 'net/https'
TOKEN=''
https=Net::HTTP.new('game.coderunner.jp',443);https.use_ssl=true
#https=Net::HTTP.new('sample.coderunner.jp',80)
File.open('runner_algo.txt','ab'){|fout|
cnt=0
loop{
	resp=https.get("/infoJson?token="+TOKEN)
	redo if resp.code.to_i!=200
	json=begin
		JSON.parse(resp.body)
	rescue
		{'power'=>Float::INFINITY,'hps'=>[0]}
	end
	if !json['hps'].empty? && json['hps'][0]*0.6<=json['power']
		resp=https.get("/enter?token="+TOKEN)
		redo if resp.code.to_i!=200
		#fout.puts s
		fout.puts resp.body
		fout.flush
		#puts s
		puts resp.body
		sleep(0.3)
	end
	sleep(0.2)
}
}
__END__
先頭のモンスターのHP*(最初：0.9, 諦めた後：0.6)より攻撃力が高い時攻撃.
しかし,部屋を早く抜けることに集中しすぎたらしい.
人に譲ったほうが順位が上がるのはわかるけど,部屋が止まったらどうなるのと.
ゲームルール的にどうなんだろうと思った.