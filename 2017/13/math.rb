data = File.readlines(ARGV[0])

firewall = []
data.each do |line|
  depth, range = line.split(': ').map(&:to_i)
  firewall[depth] = range
end

def clear?(firewall, delay)
  firewall.each.with_index do |range, i|
    next unless range
    period = range * 2 - 2
    return false if (i + delay) % period == 0
  end
  true
end

def severity(firewall)
  firewall.map.with_index do |range, i|
    next unless range
    period = range * 2 - 2
    i * range if i % period == 0
  end.compact.inject(:+)
end

puts severity(firewall)

delay = 0
delay += 1 until clear?(firewall, delay)

puts delay
