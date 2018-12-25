stars = File.readlines(ARGV[0]).each(&:strip!).map do |i|
  i.split(',').map(&:to_i)
end
constellations = stars.map { |s| [s] }

def distance(a, b)
  a.zip(b).map { |i, j| (j - i).abs }.inject(:+)
end

def consolidate(constellations)
  constellations.each do |stars|
    constellations.each do |other|
      next if stars == other
      if stars.any? { |s| other.any? { |o| distance(s, o) <= 3 } }
        stars.concat(other)
        return constellations.reject {|i| i == other}
      end
    end
  end
  constellations
end

begin
  puts constellations.size
  last = constellations.size
  constellations = consolidate(constellations)
end until last == constellations.size

puts constellations.size
