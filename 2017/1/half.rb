data = File.read(ARGV[0]).strip.split('').map(&:to_i)

total = 0
full = data.size
half = data.size / 2
data.each.with_index do |n, i|
  friend = (i + half) % full
  total += n if n == data[friend]
end

puts total
