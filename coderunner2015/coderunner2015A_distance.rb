#!/usr/bin/ruby
require 'net/https'
TOKEN=''
https=Net::HTTP.new('game.coderunner.jp',443);https.use_ssl=true
#https=Net::HTTP.new('sample.coderunner.jp',80)
File.open('runner_distance.txt','ab'){|fout|
https.start{
=begin
	[*1...999].each{|e|
		s=[0,e].join(',')
		resp=https.get("/query?token="+TOKEN+"&v="+s)
		redo if resp.code.to_i!=200
		fout.puts s
		fout.puts resp.body
		fout.flush
		puts s
		puts resp.body
		sleep(1)
	}
=end
	[*0...999].each{|e|
		next if e==395
		s=[395,e].join(',')
		resp=https.get("/query?token="+TOKEN+"&v="+s)
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

__END__
0,395
261