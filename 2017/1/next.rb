data = File.read(ARGV[0]).strip.split('').map(&:to_i)
data << data.first

total = 0
data.each_cons(2) do |i, j|
  total += i if i == j
end

puts total
