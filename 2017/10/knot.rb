input = File.read(ARGV[0]).strip.split(',').map(&:to_i)
size = (ARGV[1] || 256).to_i
list = Array.new(size) { |i| i }

cur = 0
skip = 0
input.each do |len|
  puts [cur, len, skip, '|', list.join(',')].inspect
  left, right= cur, (cur + len - 1) % size
  (len / 2).times do
    list[left], list[right] = list[right], list[left]
    left = (left + 1) % size
    right -= 1
    right += size if right < 0
  end
  cur = (cur + len + skip) % size
  skip += 1
end
puts list.join(',')

puts list[0] * list[1]
