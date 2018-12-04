require 'set'

input = File.readlines(ARGV[0])

def pieces(line)
  line.match(/#(\d+) @ (\d+),(\d+): (\d+)x(\d+)/).captures.map(&:to_i)
end

counts = Array.new(1000) { Array.new(1000) { 0 } }
ids = Array.new(1000) { Array.new(1000) { [] } }
loners = Set.new

input.each do |line|
  id, x, y, w, h = pieces(line)
  loners << id

  w.times do |i|
    h.times do |j|
      counts[x + i][y + j] += 1
      ids[x + i][y + j] << id
    end
  end
end

ids.flatten(1).each do |bedfellows|
  if bedfellows.size > 1
    bedfellows.each { |id| loners.delete(id) }
  end
end

puts counts.flatten.count { |i| i > 1 }
puts loners.to_a
