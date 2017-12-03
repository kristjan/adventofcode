data = File.readlines(ARGV[0]).map do |line|
  line.split(/\s+/).map(&:to_i)
end
puts data.inspect

sum = 0
data.each do |row|
  min, max = row.minmax
  sum += max - min
end

puts sum
