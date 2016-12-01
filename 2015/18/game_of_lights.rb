ON  = '#'
OFF = '.'

grid = File.readlines(ARGV[0]).each(&:strip!).map { |line| line.chars }
STUCK_LIGHTS = !!ARGV[1]

def print_grid(grid)
  puts(grid.map { |line| line.join })
end

def step_light(grid, x, y)
  on_neighbors = 0
  (-1..1).each do |i|
    (-1..1).each do |j|
      next if i == 0 && j == 0
      nx, ny = x + i, y + j
      next if nx < 0 || ny < 0 || nx >= grid.size || ny >= grid.first.size
      #puts "Checking #{x}, #{y} | #{nx}, #{ny}: #{grid[nx][ny]}"
      on_neighbors += 1 if grid[nx][ny] == ON
    end
  end

   #puts "#{x}, #{y}: #{on_neighbors}"

  case grid[x][y]
  when ON  then [2, 3].include?(on_neighbors) ? ON : OFF
  when OFF then on_neighbors == 3 ? ON : OFF
  end
end

def step(grid)
  new_grid = Array.new(grid.size) { Array.new(grid.first.size) }
  (0...grid.size).each do |x|
    (0...grid.first.size).each do |y|
      new_grid[x][y] = step_light(grid, x, y)
    end
  end
  new_grid
end

def stick_lights(grid)
  return grid unless STUCK_LIGHTS
  new_grid = grid.map(&:dup)
  new_grid[0][0] = new_grid[0][-1] = new_grid[-1][0] = new_grid[-1][-1] = ON
  new_grid
end

grid = stick_lights(grid)
print_grid(grid)

100.times do
  grid = stick_lights(step(grid))
  #print_grid(grid)
end

puts
puts
puts
print_grid(grid)
puts(grid.flatten.count { |ch| ch == ON })
