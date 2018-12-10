input = File.readlines(ARGV[0])

class Star
  attr_accessor :x, :y, :dx, :dy

  def initialize(x, y, dx, dy)
    @x, @y, @dx, @dy = x, y, dx, dy
  end

  def at?(test_x, test_y)
    [x, y] == [test_x, test_y]
  end

  def tick!
    self.x += dx
    self.y += dy
  end
end

def sky(stars)
  minx, maxx = stars.map(&:x).minmax
  miny, maxy = stars.map(&:y).minmax

  constellation = []

  (minx..maxx).each do |x|
    row = []
    constellation << row

    (miny..maxy).each do |y|
      row << (stars.any? { |s| s.at?(x, y) } ? '*' : ' ')
    end
  end

  constellation.transpose.map(&:join)
end

stars = input.map do |line|
  x, y, dx, dy = line.match(/position=<\s*([-\d]+),\s*([-\d]+)> velocity=<\s*([-\d]+),\s*([-\d]+)>/).captures.map(&:to_i)
  Star.new(x, y, dx, dy)
end

printed = false
ticks = 0
while true
  miny, maxy = stars.map(&:y).minmax
  spread = maxy - miny
  if spread < 20
    puts "#{ticks} ============"
    puts sky(stars)
    printed = true
  end
  if spread > 20 && printed
    exit
  end
  stars.each(&:tick!)
  ticks += 1
end
