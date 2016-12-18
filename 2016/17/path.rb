require 'digest'

input = ARGV[0]
longest = ARGV[1] == 'longest'

Point = Struct.new(:x, :y)
Path = Struct.new(:path, :pos)

def move(pos, dir)
  case dir
  when 'U'
    Point.new(pos.x, pos.y - 1)
  when 'D'
    Point.new(pos.x, pos.y + 1)
  when 'L'
    Point.new(pos.x - 1, pos.y)
  when 'R'
    Point.new(pos.x + 1, pos.y)
  end
end

def hash(str)
  digest = Digest::MD5.new
  digest << str
  digest.hexdigest.chars.first(4)
end

def valid?(ch)
  %w[b c d e f].include?(ch)
end

queue = Queue.new
queue << Path.new('', Point.new(0, 0))

while queue.size > 0
  current = queue.pop
  if current.pos.x == 3 && current.pos.y == 3
    puts [current.path, current.path.size]
    longest ? next : exit
  end

  test = hash(input + current.path)

  %w[U D L R].map.with_index do |dir, i|
    next unless valid?(test[i])
    next_pos = move(current.pos, dir)
    next unless (0...4).include?(next_pos.x) && (0...4).include?(next_pos.y)
    queue << Path.new(current.path + dir, next_pos)
  end
end

puts 'Done'
