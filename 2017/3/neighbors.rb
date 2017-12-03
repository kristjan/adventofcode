target = ARGV[0].to_i

class Spiral
  attr_accessor :x, :y, :minx, :miny, :maxx, :maxy, :dir, :n, :target, :grid

  DIRS = %i[south east north west]

  def initialize(target)
    @grid = Hash.new(0)
    @target = target
    @dir = :east
    @minx = @miny = -1
    @maxx = @maxy = 1
    @x = @y = 0
    set(0, 0, 1)
  end

  def running?
    cur < target
  end

  def inc!
    case @dir
    when :east
      @x += 1
      @dir = :north if @x == @maxx
    when :north
      @y += 1
      @dir = :west if @y == @maxy
    when :west
      @x -= 1
      @dir = :south if @x == @minx
    when :south
      @y -= 1
      if @y == @miny
        @dir = :east
        @maxx += 1
        @maxy += 1
        @minx -= 1
        @miny -= 1
      end
    end
    set(@x, @y, neighbors(@x, @y))
    puts [@x, @y, cur, @target].inspect
  end

  def neighbors(i, j)
    (-1..1).map do |k|
      (-1..1).map do |l|
        get(i + k, j + l)
      end
    end.flatten.inject(:+)
  end

  def cur
    get(@x, @y)
  end

  def get(i, j)
    @grid[[i, j]]
  end

  def set(i, j, v)
    @grid[[i, j]] = v
  end
end

s = Spiral.new(target)
s.inc! while s.running?

puts [s.x, s.y, s.cur].inspect
