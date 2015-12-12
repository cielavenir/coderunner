#!/usr/bin/ruby
#pass to sort -k2 -n -r
require 'json'
json=JSON.parse(DATA.read)
json['workers'].map{|e|
	e['speed']
}.transpose.map{|e|
	e.reduce(:+)
}.each_with_index{|e,i|
	puts '%d %d'%[i,e] if e>=90
}
__END__
{"score":12269,"workers":[{"id":0,"speed":[1,1,7,1,2,1,1,1,1,5,2,1,1,1,1,1,1,2,1,1,1,2,1,1,1,1,1,1,7,2,1,1,1,1,1,1,2,1,2,1,1,1,3,1,9,2,1,1,1,1],"time":11,"exp":447},{"id":1,"speed":[1,3,2,1,2,1,1,1,1,1,1,1,1,1,1,4,5,1,1,1,1,1,2,1,1,1,1,1,1,3,1,1,1,1,1,1,3,1,1,2,1,1,1,3,1,1,8,1,9,1],"time":11,"exp":446},{"id":2,"speed":[1,2,1,1,4,1,1,1,2,1,1,1,1,1,1,1,2,7,1,3,1,1,2,1,1,1,1,9,1,3,1,1,1,1,1,1,3,1,1,2,1,1,1,6,1,1,1,1,2,1],"time":11,"exp":446},{"id":3,"speed":[1,1,8,1,2,1,1,1,1,1,1,2,1,1,1,1,2,1,1,1,1,1,2,1,1,1,1,1,1,3,1,1,1,1,1,1,3,7,1,6,1,1,1,1,1,1,7,1,2,2],"time":11,"exp":446},{"id":4,"speed":[1,1,1,1,2,5,1,1,1,1,1,1,1,1,1,1,5,1,1,1,1,1,2,1,1,1,1,1,1,3,9,7,1,1,3,1,4,1,2,2,1,1,1,1,1,1,1,1,2,1],"time":11,"exp":446},{"id":5,"speed":[1,1,2,1,2,1,1,1,1,1,2,1,1,1,1,1,1,2,1,1,8,2,1,1,1,1,1,1,1,2,1,7,4,1,1,7,2,1,2,1,1,1,1,1,2,2,1,1,1,3],"time":11,"exp":447},{"id":6,"speed":[1,1,1,5,9,1,3,1,1,1,1,1,1,1,1,1,2,1,1,1,1,1,2,4,1,1,3,1,1,3,1,1,1,1,1,5,3,1,3,2,1,2,1,1,1,1,1,1,2,1],"time":11,"exp":446},{"id":7,"speed":[1,1,1,1,2,1,1,1,1,1,2,1,1,1,4,1,6,2,1,1,6,2,1,1,1,7,1,1,1,2,1,1,1,1,3,1,2,1,2,1,1,1,1,1,2,6,1,1,1,1],"time":11,"exp":447},{"id":8,"speed":[1,1,1,1,2,1,4,1,1,1,1,1,1,1,1,1,2,1,1,1,1,1,2,1,1,1,1,4,6,3,1,3,1,1,1,1,3,4,1,2,1,7,1,1,1,4,1,1,2,1],"time":11,"exp":446},{"id":9,"speed":[1,1,1,1,2,1,1,1,1,1,1,7,6,1,1,1,2,1,1,1,1,2,2,1,9,1,2,1,1,3,2,1,4,1,1,1,3,1,1,2,1,1,1,1,1,1,1,1,2,1],"time":11,"exp":446},{"id":10,"speed":[1,1,1,1,2,1,1,5,1,1,1,1,1,1,1,1,2,1,2,1,1,1,2,1,1,1,1,1,1,11,1,1,1,1,1,1,3,1,1,2,1,1,6,1,4,1,1,1,2,5],"time":11,"exp":446},{"id":11,"speed":[1,1,1,1,2,1,5,1,1,1,1,1,1,1,1,9,2,1,1,5,1,1,2,1,1,1,1,1,1,3,1,1,1,1,1,6,3,1,3,2,1,1,1,1,1,1,1,1,4,1],"time":11,"exp":446},{"id":12,"speed":[1,1,1,1,2,1,1,1,7,7,1,1,1,1,1,2,3,1,1,1,1,3,2,1,3,1,1,1,1,3,1,1,1,4,1,1,3,1,1,2,3,1,1,1,3,1,1,1,2,1],"time":11,"exp":446},{"id":13,"speed":[1,1,1,1,2,1,1,1,1,1,9,1,1,1,1,1,1,2,1,1,1,6,1,1,1,1,1,1,1,8,1,1,1,2,1,1,2,1,2,1,1,1,1,1,2,2,1,1,8,1],"time":11,"exp":447},{"id":14,"speed":[1,1,1,1,2,1,1,1,1,1,1,3,1,1,1,1,2,1,1,1,1,1,2,1,2,1,1,1,2,3,1,1,1,1,1,1,3,1,1,6,1,8,1,1,1,9,1,1,2,3],"time":11,"exp":446},{"id":15,"speed":[1,1,1,1,2,1,1,1,1,1,5,7,1,1,1,1,2,4,1,1,1,1,2,1,1,1,4,1,1,3,1,1,1,9,1,1,3,1,1,2,1,1,1,1,1,1,2,1,2,1],"time":11,"exp":446},{"id":16,"speed":[1,1,1,1,2,1,1,1,5,1,1,1,3,1,5,3,2,1,1,8,1,1,2,1,1,1,2,1,1,3,1,1,1,1,1,1,3,1,1,2,2,1,1,1,5,1,1,1,2,1],"time":11,"exp":446},{"id":17,"speed":[1,1,3,1,2,1,2,1,1,2,4,1,1,1,1,1,2,1,1,1,1,1,2,5,1,1,1,4,1,3,1,1,2,1,1,1,3,1,1,7,1,6,1,1,1,1,1,1,2,1],"time":11,"exp":446},{"id":18,"speed":[1,1,1,1,2,7,1,8,1,1,1,1,8,1,1,1,2,2,1,1,1,1,2,1,1,1,1,1,1,3,1,1,5,1,1,1,3,1,1,2,1,1,1,1,1,1,1,1,2,1],"time":11,"exp":446},{"id":19,"speed":[1,1,1,1,2,8,1,1,1,8,1,1,1,1,1,1,2,1,1,1,1,1,2,1,1,1,1,1,1,4,1,1,1,1,1,1,3,1,6,2,1,1,1,1,1,6,1,1,2,1],"time":11,"exp":446},{"id":20,"speed":[1,1,1,1,2,1,1,1,4,1,1,1,1,1,4,1,2,1,8,1,1,1,2,1,5,1,1,1,1,3,3,1,1,1,1,1,3,1,1,2,1,1,7,1,1,1,1,1,2,1],"time":11,"exp":446},{"id":21,"speed":[1,1,1,1,2,6,1,4,1,1,1,1,3,1,1,1,2,1,1,1,1,1,2,1,1,1,1,1,1,3,1,1,8,1,1,1,3,1,1,2,1,1,1,1,9,1,1,1,2,1],"time":11,"exp":446},{"id":22,"speed":[1,1,5,1,2,1,1,2,1,1,1,1,1,8,1,1,2,1,1,1,1,1,2,1,1,1,1,1,1,3,1,1,1,1,4,1,3,1,1,2,1,1,1,4,1,8,1,1,2,1],"time":11,"exp":446},{"id":23,"speed":[1,1,1,1,2,1,1,1,5,1,1,1,1,3,1,1,2,1,1,1,1,9,2,1,5,1,1,3,1,3,1,1,1,1,1,1,3,1,1,2,4,1,1,1,1,3,1,1,2,1],"time":11,"exp":446},{"id":24,"speed":[1,1,1,5,2,1,1,1,1,1,1,1,1,1,1,1,2,1,1,1,1,1,2,3,1,1,1,8,1,3,1,1,1,1,1,1,3,6,4,2,1,1,4,1,1,1,1,1,2,2],"time":11,"exp":446},{"id":25,"speed":[1,1,4,1,2,9,1,1,9,1,4,1,3,1,1,1,2,1,1,1,1,1,2,1,1,2,1,1,1,3,1,1,1,1,1,1,3,1,1,2,1,1,1,1,1,1,1,1,2,1],"time":11,"exp":446},{"id":26,"speed":[1,1,1,1,2,1,1,1,1,1,2,1,1,7,9,1,1,2,1,1,1,10,1,1,1,1,1,1,1,2,1,1,1,1,1,1,2,1,2,1,1,1,1,1,2,2,1,4,1,1],"time":11,"exp":447},{"id":27,"speed":[1,1,1,1,2,1,1,8,1,1,8,1,1,1,1,1,2,1,1,2,1,1,3,1,1,1,1,1,1,3,1,1,1,8,1,1,3,1,1,2,1,1,1,3,1,1,1,1,2,1],"time":11,"exp":446},{"id":28,"speed":[1,1,1,1,2,3,1,1,1,3,1,1,4,1,1,1,2,1,1,1,1,6,6,1,1,1,1,1,1,3,1,1,1,1,4,1,3,1,1,2,7,1,1,1,1,1,1,1,2,1],"time":11,"exp":446},{"id":29,"speed":[1,1,1,1,2,1,1,3,1,1,1,1,4,3,1,1,2,1,1,1,1,1,3,1,1,4,5,1,3,3,1,9,1,1,1,1,3,1,1,2,1,1,1,1,1,1,1,1,2,1],"time":11,"exp":446},{"id":30,"speed":[6,1,1,1,2,2,1,1,1,1,9,2,1,7,1,2,2,1,1,1,1,1,2,1,1,1,1,1,1,3,3,1,1,1,1,2,3,1,1,2,1,1,1,1,1,1,1,1,2,1],"time":11,"exp":446},{"id":31,"speed":[1,1,1,1,2,1,1,1,1,2,1,1,1,1,1,7,2,1,2,1,1,1,3,1,1,1,1,1,1,3,1,1,1,1,1,1,3,9,7,2,3,1,1,1,1,1,1,1,2,1],"time":11,"exp":446},{"id":32,"speed":[1,1,1,1,2,1,1,1,1,4,2,1,1,1,1,1,2,1,1,1,1,1,2,1,1,1,1,1,1,3,2,1,1,1,1,9,3,3,1,2,1,1,1,1,3,9,1,1,2,1],"time":11,"exp":446},{"id":33,"speed":[1,1,2,1,2,7,1,1,1,1,1,1,1,5,1,1,2,5,1,3,1,1,2,1,1,1,1,1,1,6,3,1,1,1,1,4,3,1,1,2,1,1,1,1,1,1,1,1,2,1],"time":11,"exp":446},{"id":34,"speed":[1,1,1,1,2,1,1,1,1,1,1,1,1,1,1,1,2,1,1,1,1,1,9,5,1,1,1,1,1,3,2,1,1,1,1,1,3,1,1,2,6,1,1,1,1,1,9,1,2,1],"time":11,"exp":446},{"id":35,"speed":[1,1,1,1,2,1,1,1,1,1,1,1,1,1,1,1,2,1,1,2,4,3,2,9,1,3,2,1,1,3,1,1,2,1,1,3,3,1,1,2,1,1,1,6,1,1,1,1,2,1],"time":11,"exp":446},{"id":36,"speed":[2,1,4,1,2,1,1,1,1,1,1,1,6,1,1,1,2,3,1,1,1,1,7,1,1,1,1,1,4,3,1,3,1,1,1,1,3,1,1,2,1,1,1,1,1,1,1,5,2,1],"time":11,"exp":446},{"id":37,"speed":[1,1,1,1,3,1,1,1,1,3,1,1,7,1,1,1,2,4,1,1,1,1,2,1,1,1,1,1,1,3,1,1,1,1,1,1,3,4,1,2,1,3,1,1,8,1,2,1,2,1],"time":11,"exp":446},{"id":38,"speed":[1,1,3,1,2,1,1,1,1,1,3,1,9,1,1,1,1,3,1,1,1,2,1,1,1,2,1,1,1,2,1,1,1,1,1,1,2,1,2,1,1,7,1,6,2,2,1,1,1,2],"time":11,"exp":447},{"id":39,"speed":[1,1,1,9,2,1,1,1,1,1,1,1,1,1,1,1,2,1,1,4,2,1,2,6,7,1,1,1,1,5,1,1,1,1,1,1,3,1,1,2,1,1,1,1,1,1,1,1,2,1],"time":11,"exp":446},{"id":40,"speed":[1,2,1,1,2,2,1,1,4,1,1,1,1,1,1,1,2,1,1,1,1,1,2,3,1,1,1,1,1,3,1,1,7,1,1,1,3,1,1,2,1,6,1,1,1,1,1,1,9,1],"time":11,"exp":446},{"id":41,"speed":[1,9,1,1,2,1,1,1,1,1,1,1,1,1,1,1,2,8,1,1,1,1,2,1,1,1,1,1,1,3,1,1,1,1,1,1,3,1,8,2,1,1,2,1,1,1,1,3,2,1],"time":11,"exp":446},{"id":42,"speed":[1,1,1,1,2,1,1,3,2,1,1,1,1,3,1,1,4,1,1,1,1,1,2,4,1,1,1,1,9,6,1,1,1,1,1,1,3,1,1,2,1,1,1,5,1,1,1,1,2,1],"time":11,"exp":446},{"id":43,"speed":[1,1,1,6,2,1,1,1,1,3,1,1,1,1,2,1,2,1,3,1,1,1,7,1,1,1,1,1,1,4,1,1,1,1,1,1,3,1,1,2,1,8,1,1,1,1,3,1,2,1],"time":11,"exp":446},{"id":44,"speed":[1,1,1,1,6,1,6,1,1,1,1,1,1,1,1,1,2,1,1,1,1,1,2,1,1,1,1,1,1,3,5,1,1,1,1,1,3,1,1,6,1,1,1,1,1,1,9,1,2,1],"time":11,"exp":446},{"id":45,"speed":[1,1,1,3,2,1,1,1,1,1,1,1,1,1,1,1,2,1,1,1,1,1,2,1,1,1,1,1,1,3,1,1,1,1,8,1,3,1,3,2,1,9,1,3,1,1,1,4,3,1],"time":11,"exp":446},{"id":46,"speed":[1,1,1,7,2,1,1,1,1,1,1,1,1,1,1,1,2,1,7,1,1,1,2,1,1,1,1,1,1,3,1,1,1,1,1,7,4,1,1,2,1,1,1,6,1,1,1,2,2,1],"time":11,"exp":446},{"id":47,"speed":[1,1,5,1,2,1,1,1,1,1,1,1,1,1,8,1,2,1,6,1,1,1,3,1,1,1,1,1,1,3,1,1,1,2,1,1,3,1,1,2,1,1,1,1,1,1,1,7,3,1],"time":11,"exp":446},{"id":48,"speed":[1,1,1,1,2,1,3,1,1,1,1,1,1,1,1,1,4,7,1,1,1,1,2,1,1,1,1,1,1,4,1,1,1,1,1,1,7,5,7,2,1,1,1,1,1,1,1,1,2,1],"time":11,"exp":446},{"id":49,"speed":[1,1,1,1,5,1,7,1,1,1,2,1,1,1,1,9,1,2,1,1,1,2,3,1,1,1,7,1,1,2,1,1,1,1,1,1,2,1,2,1,1,1,1,1,2,2,1,1,1,1],"time":11,"exp":447}],"tasks":[],"outsources":[]}