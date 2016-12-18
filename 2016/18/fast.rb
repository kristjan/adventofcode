input = ARGV[0]
COLS = input.size
rows = ARGV[1].to_i
debug = ARGV[2] == 'debug'

MASK = 2 ** COLS - 1

def count_safe(row)
  traps = 0
  while row > 0
    row &= row - 1
    traps += 1
  end
  return COLS - traps
end

def display(row)
  puts row.to_s(2).rjust(COLS, '0').tr('01', '.^')
end

prev = input.tr('.^', '01').to_i(2)
safe = count_safe(prev)
print(prev) if debug
1.upto(rows - 1) do |row|
  print "#{row}\r" if row % 1000 == 0
  current = ((prev << 1) ^ (prev >> 1)) & MASK
  safe += count_safe(current)
  prev = current
  print(prev) if debug
end

puts safe
