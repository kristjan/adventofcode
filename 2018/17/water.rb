input = File.readlines(ARGV[0]).each(&:strip!)

SPRINGY, SPRINGX = [0, 500]

DEBUG = false
def debug(*args)
  puts(*args) if DEBUG
end

class Scan
  attr_reader :minx, :miny, :maxx, :maxy, :scan

  def initialize(input)
    parse!(input)
  end

  def min_clay
    @min_clay ||= scan.map { |yrow| yrow.index(?#) || Float::INFINITY }.min
  end

  def to_s
    scan.map { |yrow| yrow[(min_clay - 1)..-1].join }.join("\n")
  end

  def waterfall!(y, x)
    debug "Waterfall at #{y}, #{x}"
    while y <= maxy && !clay?(y, x)
      scan[y][x] = ?|
      y += 1
    end
    [y - 1, x]
  end

  def wet_tiles
    scan[miny..maxy].flatten.count { |ch| [?|, ?~].include?(ch) }
  end

  def pool_tiles
    scan[miny..maxy].flatten.count { |ch| [?~].include?(ch) }
  end

  def clay?(y, x)
    scan[y][x] == ?#
  end

  def water?(y, x)
    scan[y][x] == ?~
  end

  def open?(y, x)
    y < maxy && scan[y + 1][x] == ?.
  end

  def supported?(y, x)
    y < maxy && (clay?(y + 1, x) || water?(y + 1, x))
  end

  def fill!(y, startx)
    left = right = startx
    left -= 1 while left >= 0 && !clay?(y, left) && supported?(y, left)
    right += 1 while right <= maxx && !clay?(y, right) && supported?(y, right)
    basin = clay?(y, left) && clay?(y, right)
    ch = basin ? ?~ : ?|
    scan[y][left] = ?| unless clay?(y, left)
    scan[y][right] = ?| unless clay?(y, right)
    ((left + 1)...right).each { |x| scan[y][x] = ch }
    basin
  end

  def fill_all!(y)
    xs = all_indexes(scan[y], ?|)
    xs.each { |x| fill!(y, x) }
  end

  def all_indexes(row, ch)
    [].tap do |indexes|
      row.each.with_index { |rc, i| indexes << i if rc == ch }
    end
  end

  def springs(y)
    all_indexes(scan[y], ?|).select do |x|
      debug [y, x, open?(y, x)].inspect
      open?(y, x)
    end
  end

  def water!(y, x)
    debug "Falling from #{y}, #{x}"
    filly, _fillx= waterfall!(y, x)
    begin
      debug "Filling from #{filly}, #{x}"
      filling = fill!(filly, x)
      filly -= 1
    end until !filling
    newy = filly + 1
    springs(newy).each { |springx| water!(newy, springx) }
  end

  private

  def parse!(input)
    coords = input.map do |line|
      solo_axis, solo_val, _range_axis, range =
        line.split(', ').map{|s| s.split(?=)}.flatten
      if solo_axis == ?x
        [solo_val.to_i, eval(range).to_a]
      else
        [eval(range).to_a, solo_val.to_i]
      end
    end
    @minx, @maxx = coords.map(&:first).flatten.minmax
    @miny, @maxy = coords.map(&:last).flatten.minmax

    @scan = Array.new(maxy + 1) { Array.new(maxx + 2) { ?. } }
    coords.each do |xs, ys|
      case xs
      when Integer
        ys.each { |y| @scan[y][xs] = ?# }
      when Array
        xs.each { |x| @scan[ys][x] = ?# }
      end
    end
    @scan[SPRINGY][SPRINGX] = ?|
  end
end

scan = Scan.new(input)
scan.water!(SPRINGY, SPRINGX)
puts scan
puts "Wet: #{scan.wet_tiles}"
puts "Pools: #{scan.pool_tiles}"
