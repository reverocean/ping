def ping (domain_name)
  puts "ping -c 1 #{domain_name}"
  `ping -c 1 #{domain_name}`
end

def ip (domain_name)
  ips = []
  domain_name.split("\;").each do |name|
    if name && name.gsub(" ", "")
      ip_reg = /.*\((.*)\)/
      ping_result = ping name
      if ping_result.match(ip_reg)
        ips << ping_result.scan(ip_reg)[0][0]
        next
      end

      ping_result = ping "www.#{name}"
      if ping_result.match(ip_reg)
        ips << ping_result.scan(ip_reg)[0][0]
        next
      end
      ips << "can't ping"
    end
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

File.open('result.csv', 'w') do |f2|
  File.open(csv_file, "r").each_line do |line|
    lines = line.gsub("\"", "").split

    lines.each do |l|
      if l.match /(.*;);(.*)/
        domains = l.scan(/(.*;);(.*)/)[0]
        domains[2] = ping_r(domains[1], ip(domains[0]))
        f2.puts "\"#{domains.join("\";\"")}\""
      end
    end
  end
end

