dimensions = File.readlines(ARGV[0]).map do |line|
  line.strip.split('x').map(&:to_i)
end

lengths = dimensions.map do |l, w, h|
  smaller = [l, w, h].sort.first(2)
  smaller.inject(:+) * 2 + (l * w * h)
end

puts lengths.inject(:+)
