input = ARGV[0]
cols = input.size
rows = ARGV[1].to_i
debug = ARGV[2] == 'debug'

SAFE = ?.
TRAP = ?^

def count_safe(row)
  row.delete('^').size
end

def tile(row, left, center, right)
  left_tile = left < 0 ? SAFE : row.chars[left]
  right_tile = right >= row.size ? SAFE : row.chars[right]
  case [left_tile, right_tile]
  when [SAFE, TRAP] then TRAP
  when [TRAP, SAFE] then TRAP
  else SAFE
  end
end

prev = input
safe = count_safe(prev)
puts prev if debug
1.upto(rows - 1) do |row|
  print "#{row}\r" if row % 1000 == 0
  current = cols.times.map { |col| tile(prev, col - 1, col, col + 1) }.join
  safe += count_safe(current)
  prev = current
  puts prev if debug
end

puts safe
