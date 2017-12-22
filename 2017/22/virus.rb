data = File.readlines(ARGV[0]).each(&:strip!).map{|l| l.split('')}
iterations = ARGV[1].to_i
puts data.inspect

grid = Hash.new('.')
data.each.with_index do |row, x|
  row.each.with_index do |spot, y|
    grid[[x, y]] = spot
  end
end

x = y = data.size / 2
infected = 0
dir = %i[north east south west]

def move(x, y, dir)
  result = case dir
  when :north then [x - 1, y]
  when :south then [x + 1, y]
  when :east  then [x, y - 1]
  when :west  then [x, y + 1]
  end
  result
end

def print(grid)
  minx = grid.keys.map(&:first).min
  maxx = grid.keys.map(&:first).max
  miny = grid.keys.map(&:last).min
  maxy = grid.keys.map(&:last).max
  str = (minx..maxx).map do |x|
    (miny..maxy).map do |y|
      grid[[x, y]]
    end.join
  end.join("\n")
  puts
  puts str
end

print(grid)
iterations.times do
  cur = grid[[x, y]]
  #puts [x, y, cur].inspect
  case cur
  when '.'
    infected += 1
    dir = dir.rotate(1)
    grid[[x, y]] = '#'
  when '#'
    grid[[x, y]] = '.'
    dir = dir.rotate(3)
  else
    raise grid[[x, y]]
  end
  x, y = move(x, y, dir.first)
  #print(grid)
end
print(grid)

puts infected
