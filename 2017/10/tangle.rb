input = File.read(ARGV[0]).strip.chars.map(&:ord)
input.concat([17, 31, 73, 47, 23])
size = 256
list = Array.new(size) { |i| i }

cur = 0
skip = 0

64.times do |iteration|
  input.each do |len|
    left, right = cur, (cur + len - 1) % size
    (len / 2).times do
      list[left], list[right] = list[right], list[left]
      left = (left + 1) % size
      right -= 1
      right += size if right < 0
    end
    cur = (cur + len + skip) % size
    skip += 1
  end
end

dense = []
while list.any?
  set = list[0...16]
  list = list[16..-1]
  dense << set.inject(:^)
end

puts dense.map { |i| i.to_s(16).rjust(2, '0') }.join
