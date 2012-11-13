aa = []
"abc;def;abc".split(";").each do |a|
  aa << "*#{a}"
end

puts aa.join(";") + ";"