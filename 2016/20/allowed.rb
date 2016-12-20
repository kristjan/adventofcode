input = File.read(ARGV[0])
  .split("\n")
  .map {|l| l.split("-").map(&:to_i)}
  .sort_by(&:first)

MAX_IP = 2**32

ranges = []

input.each do |min, max|
  range_index = ranges.index do |r|
    r.include?(min) || r.include?(max)
  end
  if range_index
    range = ranges[range_index]
    new_range = ([range.min, min].min)..([range.max, max].max)
    ranges[range_index] = new_range
  else
    ranges << (min..max)
  end
end

total = ranges.map(&:size).inject(:+)

puts MAX_IP - total
