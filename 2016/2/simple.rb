directions = File.read(ARGV[0]).split("\n").map(&:chars)
puts directions.inspect


keypad = [
  [1, 2, 3],
  [4, 5, 6],
  [7, 8, 9]
]

row = col = 1

def move(row, col, dir)
  puts "Moving #{dir}"
  case dir
  when 'U' then row -= 1
  when 'D' then row += 1
  when 'L' then col -= 1
  when 'R' then col += 1
  end
  row = 0 if row < 0
  row = 2 if row > 2
  col = 0 if col < 0
  col = 2 if col > 2
  [row, col]
end

code = []

directions.each do |line|
  line.each do |dir|
    row, col = move(row, col, dir)
  end
  puts "#{row} #{col} #{keypad[row][col]}"
  code << keypad[row][col]
end

puts code.join
