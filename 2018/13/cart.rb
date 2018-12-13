DEBUG = false

tracks = File.readlines(ARGV[0]).map(&:chomp).map(&:chars)

def debug(*args)
  puts(*args) if DEBUG
end

class Cart
  attr_accessor :row, :col, :dir, :upcoming_turns

  def initialize(row, col, dir)
    @row = row
    @col = col
    @dir = dir
    @upcoming_turns = %i[left straight right]
  end

  def pos
    [row, col]
  end

  def move!
    debug ['Moving', dir].inspect
    case dir
    when :north then @row -= 1
    when :south then @row += 1
    when :east  then @col += 1
    when :west  then @col -= 1
    end
  end

  def turn!(ch)
    debug ['Turning', ch, dir].inspect
    case ch
    when ?/
      case dir
      when :north then @dir = :east
      when :east  then @dir = :north
      when :south then @dir = :west
      when :west  then @dir = :south
      end
    when ?\\
      case dir
      when :north then @dir = :west
      when :west  then @dir = :north
      when :south then @dir = :east
      when :east  then @dir = :south
      end
    when ?+
      @dir = rotate(dir, upcoming_turns.first)
      upcoming_turns.rotate!
    end
  end

  def rotate(dir, turn)
    return dir if turn == :straight
    dirs = %i[north east south west]
    dirs.rotate! while dirs.first != dir
    case turn
    when :right then dirs.rotate!(1)
    when :left then dirs.rotate!(-1)
    end
    dirs.first
  end

  def to_s
    [row, col, dir].to_s
  end
end

def dir(ch)
  case ch
  when ?< then :west
  when ?> then :east
  when ?^ then :north
  when ?v then :south
  end
end

def track_dir(ch)
  case ch
  when ?<, ?> then ?-
  when ?^, ?v then ?|
  end
end

def cart_ch(dir)
  case dir
  when :north then ?^
  when :south then ?v
  when :east  then ?>
  when :west  then ?<
  end
end

def show(tracks, carts)
  out = tracks.map(&:join)
  carts.each do |cart|
    row, col = cart.pos
    out[row][col] = cart_ch(cart.dir)
  end
  debug out.join("\n")
end

carts = []
show(tracks, carts)
tracks.each.with_index do |row, y|
  row.each.with_index do |ch, x|
    if dir(ch)
      carts << Cart.new(y, x, dir(ch))
      row[x] = track_dir(ch)
    end
  end
end

puts carts

def crashed?(carts)
  carts.map(&:pos).uniq.size < carts.size
end

crashed = false
while !crashed
  carts.sort_by!(&:pos)
  carts.each do |cart|
    debug "Ticking #{cart}"
    cart.move!
    row, col = cart.pos
    ch = tracks[row][col]
    case ch
    when ?/, ?\\, ?+ then cart.turn!(ch)
    end
    show(tracks, carts)
    if crashed?(carts)
      crashed = true
      break
    end
  end
end

crash_pos, _ = carts.group_by(&:pos).select{|pos, cs| cs.size > 1}.first
puts crash_pos.reverse.inspect
