require 'set'

Point = Struct.new(:x, :y)
INPUT = 1364
TARGET = Point.new(31, 39)
#TARGET = Point.new(7, 4)

def open?(point)
  x, y = point.x, point.y
  val = (x*x) + (3*x) + (2*x*y) + y + (y*y) + INPUT
  bin = val.to_s(2)
  count = bin.chars.count { |ch| ch == '1' }
  count.even?
end

def adjacent(point)
  [
    (Point.new(point.x - 1, point.y) unless point.x == 0),
    (Point.new(point.x, point.y - 1) unless point.y == 0),
    Point.new(point.x + 1, point.y),
    Point.new(point.x, point.y + 1),
  ].compact
end

Position = Struct.new(:steps, :point)

def print(size)
  maze = size.times.map do |x|
    size.times.map do |y|
      open?(Point.new(x, y)) ? '.' : '#'
    end
  end.transpose.map(&:join)
  puts maze
end

queue = Queue.new
queue << Position.new(0, Point.new(1, 1))

seen = Set.new

while queue.size > 0
  current = queue.shift

  if current.steps > 50
    puts "Seen: #{seen.size}"
    exit
  end

  puts [open?(current.point), current].inspect

  next if seen.include?(current.point)

  seen << current.point

  adjacent(current.point).each do |neighbor|
    next unless open?(neighbor)
    queue << Position.new(current.steps + 1, neighbor)
  end
end
