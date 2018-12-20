require 'set'

re = File.read(ARGV[0]).strip[1...-1]

def depth(chars)
  counts = [0]
  while chars.any?
    ch = chars.shift
    case ch
    when ?N, ?S, ?E, ?W
      counts[-1] += 1
    when ?|
      counts << 0
    when ?(
      counts[-1] += depth(chars)
    when ?)
      return counts.max
    end
  end
  counts.max
end

class Room
  attr_accessor :neighbors, :rooms, :x, :y, :distance

  def initialize(rooms, x, y)
    @rooms = rooms
    @x, @y = x, y
    @neighbors = {}
  end

  OptionFinished = Class.new(RuntimeError)
  SubFinished = Class.new(RuntimeError)

  def parse(chars)
    while chars.any?
      ch = chars.shift
      case ch
      when ?N, ?S, ?E, ?W
        ncoords = coords(ch)
        puts "#{ch} #{x} #{y} moving to #{ncoords}"
        rooms[ncoords] ||= Room.new(rooms, *ncoords)
        neighbor = rooms[ncoords]
        neighbors[ch] ||= neighbor
        opp = opposite(ch)
        unless neighbor.neighbors[opp].nil? || neighbor.neighbors[opp] == self
          raise "Expected #{ncoords} to connect #{x} #{y}"
        end
        neighbor.neighbors[opp] = self
        neighbor.parse(chars)
      when ?(
        puts "Sub"
        begin
          parse(chars)
        rescue OptionFinished
          retry
        rescue SubFinished
          # Done
        end
      when ?|
        puts "Option"
        raise OptionFinished
      when ?)
        puts "Done"
        raise SubFinished
      end
    end
  end

  def coords(dir)
    case dir
    when ?N then [x, y + 1]
    when ?S then [x, y - 1]
    when ?E then [x + 1, y]
    when ?W then [x - 1, y]
    end
  end

  def opposite(dir)
    case dir
    when ?N then ?S
    when ?S then ?N
    when ?E then ?W
    when ?W then ?E
    end
  end

  def farthest
    rooms.values.each { |r| r.distance = Float::INFINITY }

    @distance = 0

    seen = Set.new

    queue = [self]
    while queue.any?
      cur = queue.shift
      next if seen.include?(cur)
      seen << cur

      ndist = cur.distance + 1
      cur.neighbors.values.each do |n|
        n.distance = ndist if ndist < n.distance
      end

      queue.concat(cur.neighbors.values)
    end

    rooms.values.map(&:distance).max
  end
end

def display(rooms)
  minx, maxx = rooms.values.map(&:x).minmax
  miny, maxy = rooms.values.map(&:y).minmax

  puts [minx, miny, maxx, maxy].inspect
  puts '#' * ((maxx - minx + 1) * 2 + 1)
  (miny..maxy).to_a.reverse.each do |y|
    room_row = '#'
    door_row = '#'
    (minx..maxx).each do |x|
      room = rooms[[x, y]]
      if room.nil?
        room_row << ' #'
        door_row << '##'
      else
        room_row << ?. + (room.neighbors[?E] ? ?| : ?#)
        door_row << (room.neighbors[?S] ? ?- : ?#) + ?#
      end
    end
    puts [room_row, door_row]
  end
end

rooms = {}
base = Room.new(rooms, 0, 0)
rooms[[0, 0]] = base
base.parse(re.chars)
display(rooms)
puts base.farthest
puts rooms.values.count {|room| room.distance >= 1000}
