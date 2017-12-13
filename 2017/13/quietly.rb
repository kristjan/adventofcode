data = File.readlines(ARGV[0])

class Scanner
  attr_accessor :delta, :pos, :range

  def initialize(range)
    @pos = 0
    @range = range
    @count = (range * 2) - 2
  end

  def step
    @pos = (@pos + 1) % @count
  end

  def to_s
    "#{range} / #{pos}"
  end

  def pos=(p)
    @pos = p % @count
  end
end

delay = 0

loop do
  puts "=== #{delay}" if delay % 1000 == 0
  firewall = []

  data.each do |line|
    depth, range = line.split(': ').map(&:to_i)
    firewall[depth] = Scanner.new(range)
    firewall[depth].pos = delay
  end

  me = -1
  hit = false
  while me < firewall.size
    me += 1
    #puts
    #puts me
    #puts "\t" + firewall.map{|s| s&.pos}.join(',')
    scanner = firewall[me] if me >= 0
    if scanner&.pos == 0
      hit = true
      break
    end
    firewall.each{|s| s&.step}
    #puts "\t" + firewall.map{|s| s&.pos}.join(',')
  end

  break unless hit
  delay += 1
end

puts "Delay: #{delay}"
