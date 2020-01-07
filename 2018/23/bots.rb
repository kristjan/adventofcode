require 'pqueue'
require 'set'

class Bot
  attr_reader :x, :y, :z, :r

  def initialize(line)
    @x, @y, @z, @r = line.scan(/[-\d]+/).map(&:to_i)
  end

  def self.distance(a, b)
    a.zip(b).map { |i, j| j - i }.map(&:abs).sum
  end

  def distance_to(point)
    self.class.distance(pos, point)
  end

  def in_range(bots)
    @in_range ||= bots.count {|b| in_range?(b)}
  end

  def in_range?(other)
    distance_to(other.pos) <= r
  end

  def overlapping(bots)
    @overlapping ||= bots.count {|b| overlaps?(b)}
  end

  def overlaps?(other)
    distance_to(other.pos) <= r + other.r
  end

  def pos
    [x, y, z]
  end

  def to_s
    [pos, r, @overlapping]
  end
end

def hextree_positions(pos, radius)
  x, y, z = pos
  [
    [x - radius / 2, y, z],
    [x + radius / 2, y, z],
    [x, y - radius / 2, z],
    [x, y + radius / 2, z],
    [x, y, z - radius / 2],
    [x, y, z + radius / 2]
  ]
end

if $0 == __FILE__
  data = File.readlines(ARGV[0]).each(&:strip!)
  bots = data.map { |line| Bot.new(line) }
  puts "#{bots.size} bots"

  strongest = bots.max_by(&:r)
  in_range = strongest.in_range(bots)

  puts "In range of strongest: #{in_range}"

  minx, maxx = bots.map(&:x).minmax
  miny, maxy = bots.map(&:y).minmax
  minz, maxz = bots.map(&:z).minmax

  radius = [minx, maxx, miny, maxy, minz, maxz].map(&:abs).max * 2
  searchbot = Bot.new([0, 0, 0, radius].to_s)
  searchbot.overlapping(bots) # Set the ivar for printing

  seen = Set.new
  q = PQueue.new do |a, b|
    [-a.overlapping(bots), a.r, a.distance_to([0, 0, 0])] <=>
    [-b.overlapping(bots), b.r, b.distance_to([0, 0, 0])]
  end
  q << searchbot

  while q.size > 0 do
    searchbot = q.pop
    break if searchbot.r == 0

    sig = [*searchbot.pos, searchbot.r]
    next if seen.include?(sig)
    seen << sig

    puts "? #{searchbot.to_s}"

    new_positions = hextree_positions(searchbot.pos, searchbot.r)
    new_positions.each do |x, y, z|
      q << Bot.new([x, y, z, searchbot.r / 2].to_s)
    end
  end

  puts searchbot.inspect
end
