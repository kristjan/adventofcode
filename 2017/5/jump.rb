jumps = File.readlines(ARGV[0]).map(&:to_i)
cur = 0

steps = 0

while cur >= 0 && cur < jumps.size
  tmp = cur
  cur = cur + jumps[cur]
  jumps[tmp] += 1
  steps += 1
end

puts steps
