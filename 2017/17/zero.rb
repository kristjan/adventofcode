input, loops = ARGV.to_a.map(&:to_i)

pos = 0
length = 1

1.upto(loops) do |i|
  pos = (pos + input + 1) % length
  length += 1
  puts i if pos == 0
end
