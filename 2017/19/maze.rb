maze = File.readlines(ARGV[0]).map(&:chars).map{|l| l[0...-1]}
puts maze.map(&:inspect)


MOVEMENT = {
  north: [-1, 0],
  south: [1, 0],
  east:  [0, 1],
  west:  [0, -1]
}

dir = :south

def opp(dir)
  case dir
  when :north then :south
  when :south then :north
  when :east then :west
  when :west then :east
  end
end

def change(row, col, dir)
  dr, dc = MOVEMENT[dir]
  puts "changing #{row}, #{col}, #{dir}"
  nr, nc = row + dr, col + dc
  [nr, nc]
end

def search(maze, row, col, dir)
  tries = MOVEMENT.keys - [dir, opp(dir)]
  tries.each do |newdir|
    nr, nc = change(row, col, newdir)
    next if nr < 0 || nc < 0 || nr >= maze.size || nc >= maze[nr].size
    attempt = maze[nr][nc]
    puts "Checking #{nr} #{nc} #{attempt}"
    return newdir unless attempt == ' '
  end
end

order = ''
row, col = 0, 0
col += 1 until maze[row][col] == '|'
steps = 0

while maze[row][col] != ' '
  steps += 1
  cur = maze[row][col]
  puts [row, col, cur, dir].inspect
  case cur
  when '+'
    dir = search(maze, row, col, dir)
  when /[A-Z]/
    puts cur
    order << cur
  end
  row, col = change(row, col, dir)
end

puts order
puts steps
