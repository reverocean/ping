require "csv"

def ping (domain_name)
  `ping -c 1 #{domain_name}`
end

def ip (domain_name)
  ip_reg = /.*\((.*)\)/
  ping_result = ping domain_name
  if ping_result.match(ip_reg)
    return ping_result.scan(ip_reg)[0][0]
  end

  ping_result = ping "www.#{domain_name}"
  if ping_result.match(ip_reg)
    return ping_result.scan(ip_reg)[0][0]
  end

  return "can't ping"
end

def ping_r (inner_ip, ip)
  if inner_ip.gsub(" ", "") == ip
    return "right"
  end
  return ip
end

csv_file = ARGV[0]
if csv_file !~ /csv/
  csv_file = "#{csv_file}.csv"
end

CSV.open("result.csv", "w") do |csv|
  CSV.foreach(csv_file) do |row|
    row[2] = ping_r(row[1], ip(row[0]))
    p row
    csv << row
  end

end

