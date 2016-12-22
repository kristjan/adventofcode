input = File.read(ARGV[0]).split("\n")

Node = Struct.new(:x, :y, :size, :used, :avail, :percent)

def draw(grid)
  lines = grid.map do |line|
    line.map do |i|
      "#{i.used.to_s.ljust(3)}/#{i.size.to_s.ljust(3)}"
    end.join(' ')
  end
  puts lines
end

DF = /node-x(\d+)-y(\d+)\s+(\d+)T\s+(\d+)T\s+(\d+)T\s+(\d+)%/
def node_from_line(line)
  match = DF.match(line)
  Node.new(*(match.to_a[1..-1].map(&:to_i)))
end

nodes = input.map { |line| node_from_line(line) }

grid = Array.new(nodes.map(&:x).max + 1) { Array.new(nodes.map(&:y).max + 1) }
nodes.each { |node| grid[node.x][node.y] = node }

viable = 0
nodes.each do |i|
  nodes.each do |j|
    next if i == j
    viable += 1 if i.percent > 0 && i.used <= j.avail
  end
end

puts viable

target = grid.last[0]
puts target
draw(grid)
