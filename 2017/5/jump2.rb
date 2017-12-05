jumps = File.readlines(ARGV[0]).map(&:to_i)
cur = 0

steps = 0

while cur >= 0 && cur < jumps.size
  tmp = cur
  offset = jumps[cur]
  cur = cur + offset
  jumps[tmp] += offset >= 3 ? -1 : 1
  steps += 1
end

puts steps
