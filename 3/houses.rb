str = File.read(ARGV[0]).strip

houses = Hash.new(0)

lat, lon = 0, 0

houses[[lat, lon]] += 1

def adjustments(dir)
  case dir
  when '^' then [1, 0]
  when 'v' then [-1, 0]
  when '<' then [0, -1]
  when '>' then [0, 1]
  end
end

str.chars.each do |dir|
  dlat, dlon = adjustments(dir)
  lat += dlat
  lon += dlon
  houses[[lat, lon]] += 1
end

puts houses.size
