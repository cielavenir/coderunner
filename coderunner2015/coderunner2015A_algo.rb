#!/usr/bin/ruby
a=[]
while s=gets
	n=s.chomp.split(',').map(&:to_i)[1]
	l=gets.to_i
	a<<[l,n]
end
a.sort!

require 'net/https'
TOKEN=''
https=Net::HTTP.new('game.coderunner.jp',443);https.use_ssl=true
#https=Net::HTTP.new('sample.coderunner.jp',80)
File.open('runner_algo.txt','ab'){|fout|
	z=[395,518]
	a.pop
	i=a.size-1
	while i>0
		0.upto([i-1,10].min){|j|
			s=(z+[a[i][1]]+[a[j][1]]).join(',')
			resp=https.get("/query?token="+TOKEN+"&v="+s)
			redo if resp.code.to_i!=200
			fout.puts s
			fout.puts resp.body
			fout.flush
			puts s
			puts resp.body
			sleep(1)
			if resp.body!='0'
				z=z+[a[i][1]]+[a[j][1]]
				a.delete_at(i)
				a.delete_at(j)
				i-=1 # 下側をもう1個潰すから
				break
			end
		}
		i-=1
	end
}

__END__
まず、前提として、対角線の本数は多ければ多いほど良い。
よって、まず、各2点対を木の辺とみなし、頂点0からの木の高さ全探索(999回)で求める。
今回は、395が距離261で最遠であった。
そして、395から各点への距離を求めておく。
今回518が最遠なので、リストを[395,518]とする。
距離リストを距離が小さい順に並び替え、後ろから順番に(変数i)、前から10個(変数j)を見て、リストに追加可能かどうか確認する。
なお、今回の問題では乱択は一切使用していない。

[Answer]
906,235,112,705,592,947,2,476,478,365,471,459,13,820,970,342,977,534,180,570,790,594,276,379,561,241,430,89,203,152,636,714,197,244,198,265,996,851,771,315,602,837,857,637,31,66,409,229,913,992,349,589,319,819,297,87,185,240,719,343,363,963,630,920,552,217
11876