input = File.read(ARGV[0]).split("\n").map do |line|
  [
    line[0..5],
    line[5..10],
    line[10..15]
  ].map(&:strip).map(&:to_i).sort
end

count = input.count do |a, b, c|
  a + b > c
end

puts count
