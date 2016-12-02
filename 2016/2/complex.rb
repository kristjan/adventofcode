directions = File.read(ARGV[0]).split("\n").map(&:chars)
puts directions.inspect

KEYPAD = <<-STR.split("\n").map(&:chars)
.......
...1...
..234..
.56789.
..ABC..
...D...
.......
STR

row, col = 3, 1

def move(row, col, dir)
  puts "Moving #{dir}"
  diff = case dir
  when 'U' then [-1, 0]
  when 'D' then [1, 0]
  when 'L' then [0, -1]
  when 'R' then [0, 1]
  end
  potential = [row + diff[0], col + diff[1]]
  KEYPAD[potential[0]][potential[1]] == '.' ? [row, col] : potential
end

code = []

directions.each do |line|
  line.each do |dir|
    row, col = move(row, col, dir)
  end
  puts "#{row} #{col} #{KEYPAD[row][col]}"
  code << KEYPAD[row][col]
end

puts code.join
