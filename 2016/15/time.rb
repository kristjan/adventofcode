Disc = Struct.new(:positions, :initial)

#DISCS = [
  #Disc.new(5, 4),
  #Disc.new(2, 1)
#]

DISCS = [
  Disc.new(17, 15),
  Disc.new(3, 2),
  Disc.new(19, 4),
  Disc.new(13, 2),
  Disc.new(7, 2),
  Disc.new(5, 0),
  Disc.new(11, 0),
]

TIMES = (1..DISCS.size).to_a

def calculate_positions(discs, times)
  discs.zip(times).map do |disc, time|
    (disc.initial + time) % disc.positions
  end
end

i = 0
while true
  test_times = TIMES.map {|t| t + i}
  positions = calculate_positions(DISCS, test_times)
  if positions.all?(&:zero?)
    puts "First success is #{i}"
    exit
  end
  i += 1
end
