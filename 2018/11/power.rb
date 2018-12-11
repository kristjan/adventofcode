SERIAL = ARGV[0].to_i

def power(x, y)
  rack_id = x + 10
  level = rack_id * y
  level += SERIAL
  level *= rack_id
  hundreds = level.to_s.rjust(100)[-3].to_i
  hundreds - 5
end

def total(grid, x, y, size)
  return -Float::INFINITY if x + size >= 300 || y + size >= 300

  t = 0
  0.upto(size - 1) do |dx|
    0.upto(size - 1) do |dy|
      t += grid[x + dx][y + dy]
    end
  end
  t
end

grid = Array.new(300) do |x|
  Array.new(300) do |y|
    power(x, y)
  end
end

bestx = besty = 0
bestsize = 1
max = total(grid, bestx, besty, bestsize)
1.upto(299).each do |size|
  puts size
  0.upto(300 - size).each do |x|
    0.upto(300 - size).each do |y|
      p = total(grid, x, y, size)
      if p > max
        max = p
        bestx = x
        besty = y
        bestsize = size
        puts [bestx, besty, max, bestsize].inspect
      end
    end
  end
end

puts [bestx, besty, max, bestsize].inspect
