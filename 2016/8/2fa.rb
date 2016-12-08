input = File.read(ARGV[0]).split("\n")

ROWS = 6
COLS = 50

screen = Array.new(ROWS) { Array.new(COLS) { '.' } }

def print(screen)
  puts screen.map(&:join)
end

def rect(screen, width, height)
  height.times do |row|
    width.times do |col|
      screen[row][col] = '#'
    end
  end
  screen
end

def rotate_column(screen, id, amount)
  puts "Rotate col #{id} by #{amount}"
  col = screen.map { |row| row[id] }
  col = col.rotate(-amount)
  screen.each.with_index do |row, i|
    row[id] = col[i]
  end
  screen
end

def rotate_row(screen, id, amount)
  puts "Rotate row #{id} by #{amount}"
  screen[id] = screen[id].rotate(-amount) # Spec is backwards from Ruby
  screen
end

input.each do |cmd|
  parts = cmd.split(' ')
  puts parts.inspect
  screen = case parts[0]
  when 'rect' then
    w, h = parts[1].split('x').map(&:to_i)
    rect(screen, w, h)
  when 'rotate' then
    id, amount = /=(\d+) by (\d+)/.match(cmd).to_a[1..-1].map(&:to_i)
    case parts[1]
    when 'row' then rotate_row(screen, id, amount)
    when 'column' then rotate_column(screen, id, amount)
    end
  end

  print(screen)
end

count = screen.flatten.count{|ch| ch == '#'}
puts count
