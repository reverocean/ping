aa = []
"ksgym.cn;ksgym.com;cdatpt.com;bestg.cn;".split(";").each do |a|
  aa << "*#{a}"
end

puts aa.join(";") + ";"