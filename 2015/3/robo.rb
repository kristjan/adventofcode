str = File.read(ARGV[0]).strip

houses = Hash.new(0)

slat, slon = 0, 0
rlat, rlon = 0, 0

houses[[0, 0]] += 2

def adjustments(dir)
  case dir
  when '^' then [1, 0]
  when 'v' then [-1, 0]
  when '<' then [0, -1]
  when '>' then [0, 1]
  end
end

movements = str.chars
santa_moves = movements.values_at(*movements.each_index.select(&:even?))
robot_moves = movements.values_at(*movements.each_index.select(&:odd?))

santa_moves.each do |dir|
  dlat, dlon = adjustments(dir)
  slat += dlat
  slon += dlon
  houses[[slat, slon]] += 1
end

robot_moves.each do |dir|
  dlat, dlon = adjustments(dir)
  rlat += dlat
  rlon += dlon
  houses[[rlat, rlon]] += 1
end

puts houses.size
