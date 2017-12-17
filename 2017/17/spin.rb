input, loops = ARGV.to_a.map(&:to_i)

buffer = [0]

pos = 0

1.upto(loops) do |i|
  puts i if i % 10000 == 0
  pos = (pos + input + 1) % buffer.size
  buffer = buffer[0..pos] + [i] + buffer[(pos + 1)..-1]
end

i2017 = buffer.index(2017)
puts buffer[i2017 + 1]

i0 = buffer.index(0)
puts buffer[i0 + 1]

#puts buffer.join(',')
