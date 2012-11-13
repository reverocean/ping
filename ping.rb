require "csv"

def ping (domain_name)
  puts "ping -c 1 #{domain_name}"
  `ping -c 1 #{domain_name}`
end

def ip (domain_name)
  ips = []
  domain_name.split(";").each do |name|
    ip_reg = /.*\((.*)\)/
    ping_result = ping domain_name
    if ping_result.match(ip_reg)
      ips << ping_result.scan(ip_reg)[0][0]
      next
    end

    ping_result = ping "www.#{domain_name}"
    if ping_result.match(ip_reg)
      ips << ping_result.scan(ip_reg)[0][0]
      next
    end
    ips << "can't ping"
  end
  ips.join(";") + ";"
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

File.open(csv_file, "r").each_line do |line|
  lines = line.gsub("\"", "").split
  CSV.open("inter.csv", "w") do |csv|
    lines.each do |l|
      if l.match /(.*;);(.*)/
        domains = l.scan(/(.*;);(.*)/)[0]
        puts domains
        csv << domains
      end
    end
  end

end

CSV.open("result.csv", "w") do |csv|
  CSV.foreach("inter.csv") do |row|
    row[2] = ping_r(row[1], ip(row[0]))
    p row
    csv << row
  end

end

