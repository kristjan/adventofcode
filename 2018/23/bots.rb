data = File.readlines(ARGV[0]).each(&:strip!)

class Bot
	attr_reader :x, :y, :z, :r

	def initialize(line)
		@x, @y, @z, @r = line.scan(/[-\d]+/).map(&:to_i)
	end

	def self.distance(a, b)
	  a.zip(b).map { |i, j| j - i }.map(&:abs).sum
	end

	def in_range?(other)
	  self.class.distance(pos, other.pos) <= r
	end

	def pos
		[x, y, z]
	end
end

bots = data.map { |line| Bot.new(line) }
puts "#{bots.size} bots"
strongest = bots.max_by(&:r)
in_range = bots.count { |b| strongest.in_range?(b) }

puts "In range of strongest: #{in_range}"
