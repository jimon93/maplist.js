# Extend ============= {{{
# Maybe #{{{
class NilClass
  def method_missing( method_name, *args )
    nil
  end
end #}}}
# input {{{
Input = STDIN.each_line.lazy.map(&:chomp)
class << Input
  def nums( sep = ' ', converter = :to_i )
    self.map{ |line|
      line.split( sep ).map( &converter )
    }
  end
  def method_missing( method_name, *args )
    self.map{ |str| str.public_send( method_name, *args ) }
  end
end
# }}}
# Enumerable Extend #{{{
module Enumerable
  alias :filter :find_all
  def count_by(&block)
    Hash[ group_by(&block).map{ |key,vals| [key, vals.size] } ]
  end
end #}}}
# Identity #{{{
class Object
  def identity
    self
  end
end #}}}
# ==================== }}}
require "pp"
require "json"

def getArea(state)
  case state
  when '北海道' then '北海道'
  when '青森県','岩手県','宮城県','秋田県','山形県','福島県' then '東北'
  when '東京都','神奈川県','埼玉県','千葉県','茨城県','栃木県','群馬県','山梨県' then '関東'
  when '新潟県','長野県' then "信越"
  when '富山県','石川県','福井県' then "北陸"
  when '愛知県','岐阜県','静岡県','三重県' then "東海"
  when '大阪府','兵庫県','京都府','滋賀県','奈良県','和歌山県' then "近畿"
  when '鳥取県','島根県','岡山県','広島県','山口県' then "中国"
  when '徳島県','香川県','愛媛県','高知県' then "四国"
  when '福岡県','佐賀県','長崎県','熊本県','大分県','宮崎県','鹿児島県' then "九州"
  when "沖縄県" then "沖縄"
  end
end

entries = Input.map{|str|
  str.split(/ +/)
}.group_by{|entry|
  getArea(entry[0])
}.entries

json = entries.map{|genre,entries|
  entries.map{|entry|
    {
      states:entry[0],
      capitals:entry[1],
      lat:entry[2],
      lng:entry[3],
      genre:getArea(entry[0])
    }
  }
}.flatten

xml = entries.map{|genre, entries|
  xml = "<genre id='#{genre}'>"
  xml += entries.map{|entry|
    xml  = "<place latitude='#{entry[2]}' longitude='#{entry[3]}'>"
    xml += "<states>#{entry[0]}</states>"
    xml += "<capitals>#{entry[1]}</capitals>"
    xml +  "</place>"
  }.join
  xml + "</genre>"
}.join
xml = "<?xml version='1.0' encoding='UTF-8'?>\n<places>#{xml}</places>"

case ARGV[0]
when "json" then puts json.to_json
when "object" then pp json
when "xml" then puts xml
end
