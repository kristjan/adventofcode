data = File.readlines(ARGV[0])

class Scanner
  attr_reader :delta, :pos, :range

  def initialize(range)
    @pos = 0
    @range = range
    @delta = 1
  end

  def step
    if pos == 0
      @delta = 1
    elsif pos == range - 1
      @delta = -1
    end
    @pos += delta
  end

  def to_s
    "#{range} / #{pos}"
  end
end

firewall = Array.new(7)

data.each do |line|
  depth, range = line.split(': ').map(&:to_i)
  firewall[depth] = Scanner.new(range)
end

me = -1
severity = 0
while me < firewall.size
  me += 1
  scanner = firewall[me]
  puts "#{me} #{scanner&.pos}"
  if scanner&.pos == 0
    severity += me * scanner.range
  end
  firewall.each{|s| s&.step}
end

puts severity
