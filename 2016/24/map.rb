require 'set'

map = File.read(ARGV[0]).split("\n").map{|l| l.split('')}
nodes = map.flatten.select{|i| i =~ /\d/}

distances = {}

def find(map, node)
  map.each.with_index do |line, row|
    line.each.with_index do |spot, col|
      return [row, col] if spot == node
    end
  end

end

Path = Struct.new(:moves, :row, :col)

nodes.each do |src|
  pos = find(map, src)
  puts "Beginning for #{src} at #{pos.inspect}"

  nodes.each do |dst|
    next if src == dst

    pair = [src, dst].sort
    if distances[pair]
      puts "Skipping #{pair} #{distances[pair]}"
      next
    else
      puts "Searching #{pair}"
    end

    queue = Queue.new
    visited = Set.new
    visited << pos
    queue << Path.new(0, pos[0], pos[1])

    while queue.size > 0
      cur = queue.pop

      if map[cur.row][cur.col] == dst
        distances[pair] = cur.moves
        puts "Found #{pair} #{distances[pair]}"
        break
      end

      [
        [-1, 0],
        [ 1, 0],
        [ 0,-1],
        [ 0, 1],
      ].each do |dr, dc|
        nr = cur.row + dr
        nc = cur.col + dc
        next if map[nr][nc] == '#'
        next if visited.include?([nr, nc])
        visited << [nr, nc]
        queue << Path.new(cur.moves + 1, nr, nc)
      end
    end

  end
end

min = Float::INFINITY
min_path = nil

['0', *nodes].permutation.select {|i| i[0] == '0' && i[-1] == '0'}.each do |order|
  total = order.each_cons(2).map do |src, dst|
    distances[[src, dst].sort]
  end.inject(:+)
  if total < min
    min = total
    min_path = order
  end
end

puts min
puts min_path.inspect
