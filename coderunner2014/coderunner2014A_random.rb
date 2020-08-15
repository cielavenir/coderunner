#!/usr/bin/ruby
require 'net/https'
L=50
TOKEN=''
https=Net::HTTP.new('game.coderunner.jp',443)
https.use_ssl=true
File.open('runner_random.txt','ab'){|fout|
https.start{
	loop{
		s=L.times.map{[*'A'..'D'].sample}.join
		resp=https.get("/q?token="+TOKEN+"&str="+s)
		redo if resp.code.to_i!=200
		fout.puts s
		fout.puts resp.body
		fout.flush
		puts s
		puts resp.body
		sleep(1)
	}
}
}