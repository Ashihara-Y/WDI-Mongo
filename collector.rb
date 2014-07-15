require 'roo'
#require 'msgpack'
#require 'oj'
require 'redis'
require 'yajl/json_gem'
#require 'iconv'
require 'open-uri'

#docu info, doc2Roo
docTitle = 'eO_ax01_json'
uri = 'http://www.oecd.org/eco/outlook/Demand-and-Output.xls'
econOutlook = Roo::Spreadsheet.open(uri)

#eO_json = Oj.dump(econOutlook) #It doesn't work! "stack level too deep"
#eO_json = econOutlook.to_json  #It works with yajl/json_gem!

#RooObj2Matrix2Array
eO_matrix = econOutlook.to_matrix.to_a

#modif Array (BigDecimal2Float)
eO_matrix_mod = eO_matrix.each do |y| 
   y.map{|x|
     if x.instance_of?(String) 
      then x
     elsif x.instance_of?(Float) 
      then x.round(5) 
     end}
 end
#p eO_matrix_mod[4]

#Mtrix2OJ: It works! 
#eO_json = Oj.dump(eO_matrix_mod)
eO_json = JSON.generate(eO_matrix_mod)

#REDIS set&get JSON
redis = Redis.new(:host => "pub-redis-17827.us-east-mz.1.ec2.garantiadata.com", 
                  :port => 17827, 
                  :password => "1871pven")
redis.set(docTitle, eO_json)
res = redis.get(docTitle)
res_json = JSON.parse(res)
#p res_json == eO_matrix_mod
#p res_json[4]