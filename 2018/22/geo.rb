require 'set'
require 'pqueue'

DEPTH = ARGV[0].to_i
TX, TY = ARGV[1..2].map(&:to_i)
DIMX, DIMY = TX * 10, TY * 2

puts [DEPTH, TX, TY].inspect

def erosion(index)
  (index + DEPTH) % 20183
end

ROCKY = 0
WET = 1
NARROW = 2

def type(erosion)
  erosion % 3
end

geo = Array.new(DIMX) do |y|
  Array.new(DIMY) do
    { index: nil, erosion: nil, type: nil }
  end
end

(0...DIMY).each do |y|
  g = geo[0][y]
  g[:index] = y * 48271
  g[:erosion] = erosion(g[:index])
  g[:type] = type(g[:erosion])
end
(0...DIMX).each do |x|
  g = geo[x][0]
  g[:index] = x * 16807
  g[:erosion] = erosion(g[:index])
  g[:type] = type(g[:erosion])
end

geo[0][0] = {
  index: 0,
  erosion: erosion(0),
  type: type(erosion(0))
}
geo[TX][TY] = {
  index: 0,
  erosion: erosion(0),
  type: type(erosion(0))
}

(1...DIMY).each do |y|
  (1...DIMX).each do |x|
    next if [x, y] == [TX, TY]
    g = geo[x][y]
    left = geo[x-1][y]
    up = geo[x][y-1]
    g[:index] = left[:erosion] * up[:erosion]
    g[:erosion] = erosion(g[:index])
    g[:type] = type(g[:erosion])
  end
end

def neighbors(x, y)
  [
    ([x - 1, y] if x > 0),
    ([x + 1, y] if x < DIMX - 1),
    ([x, y - 1] if y > 0),
    ([x, y + 1] if y < DIMY - 1)
  ].compact
end

def usable(type)
  case type
  when ROCKY then %i[torch climbing]
  when WET then %i[climbing neither]
  when NARROW then %i[neither torch]
  end
end

Search = Struct.new(:x, :y, :tool, :time)

def bsearch(geo)
  q = PQueue.new { |a, b| a.time < b.time }
  q << Search.new(0, 0, :torch, 0)
  count = 0

  seen = Set.new

  while q.size > 0
    cur = q.pop
    print "#{count}\r"
    count += 1

    if [cur.x, cur.y] == [TX, TY]
      if cur.tool == :torch
        puts cur
        return
      else
        q << Search.new(cur.x, cur.y, :torch, 7 + cur.time)
        next
      end
    end

    next if seen.include?([cur.x, cur.y, cur.tool])
    seen << [cur.x, cur.y, cur.tool]

    cell = geo[cur.x][cur.y]

    neighbors(cur.x, cur.y).each do |nx, ny|
      n = geo[nx][ny]
      ntools = usable(n[:type])
      if ntools.include?(cur.tool)
        q << Search.new(nx, ny, cur.tool, cur.time + 1)
      else
        new_tool = (ntools & usable(cell[:type])).first
        q << Search.new(nx, ny, new_tool, cur.time + 7 + 1)
      end
    end
  end
end

def display(geo)
  geo.transpose.map do |row|
    row.map do |cell|
      case cell[:type]
      when 0 then ?.
      when 1 then ?=
      when 2 then ?|
      end
    end.join
  end.join("\n")
end

puts display(geo)
total = geo[0..TX].flat_map {|x| x[0..TY] }.map{|g| g[:type]}.inject(:+)
puts total
bsearch(geo)
