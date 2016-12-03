input = File.read(ARGV[0]).split("\n").map do |line|
  [
    line[0..5],
    line[5..10],
    line[10..15]
  ].map(&:strip).map(&:to_i)
end

cols = input.map {|l| l[0]} + input.map {|l| l[1]} + input.map {|l| l[2]}

count = 0
while cols.any?
  a, b, c = cols[0..2].sort
  cols = cols[3..-1]
  puts [a, b, c].inspect
  count += 1 if a + b > c
end

puts count
