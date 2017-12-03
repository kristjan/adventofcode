target = ARGV[0].to_i

class Spiral
  attr_accessor :x, :y, :minx, :miny, :maxx, :maxy, :dir, :n, :target

  DIRS = %i[south east north west]

  def initialize(target)
    @target = target
    @dir = :east
    @minx = @miny = -1
    @maxx = @maxy = 1
    @x = @y = 0
    @n = 1
  end

  def running?
    n < target
  end

  def inc!
    @n += 1
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
    #puts [@x, @y, @n, @x.abs + @y.abs, @target].inspect
  end
end

s = Spiral.new(target)
s.inc! while s.running?

puts [s.x, s.y, s.x.abs + s.y.abs].inspect
