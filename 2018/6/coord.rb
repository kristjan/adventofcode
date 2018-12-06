require 'set'

input = File.readlines(ARGV[0])
alpha = ((?a..?z).to_a + (?A..?Z).to_a).first(input.size)

Point = Struct.new(:x, :y, :name)

POINTS = input.map do |line|
  x, y = line.strip.split(',').map(&:to_i).reverse
  Point.new(x, y, alpha.shift)
end

TIE = Point.new(nil, nil, '.')

maxx = POINTS.map(&:x).max
maxy = POINTS.map(&:y).max

Cell = Struct.new(:point, :safe)

grid = Array.new(maxx) { Array.new(maxy) }

def distance(x, y, point)
  (point.y - y).abs + (point.x - x).abs
end

def closest(x, y)
  min = Float::INFINITY
  minpoint = nil

  POINTS.each do |point|
    dist = distance(x, y, point)
    if dist == min
      minpoint = TIE
    elsif dist < min
      minpoint = point
      min = dist
    end
  end

  minpoint
end

def safe(x, y)
  POINTS.map do |point|
    distance(x, y, point)
  end.inject(:+) < 10000
end

grid.size.times do |x|
  grid.first.size.times do |y|
    point = closest(x, y)
    grid[x][y] = Cell.new(point, safe(x, y))
  end
end

edges = Set.new
(0..(maxx + 1)).each do |x|
  edges << closest(x, 0)
  edges << closest(x, maxy)
end
(0..(maxy + 1)).each do |y|
  edges << closest(0, y)
  edges << closest(maxx, y)
end

hist = grid
  .flatten
  .map(&:point)
  .reject {|point| edges.include?(point)}
  .group_by(&:name)
  .map {|name, points| [name, points.size]}

puts hist
  .sort_by(&:last)
  .map(&:inspect)

puts grid.flatten.count(&:safe)
