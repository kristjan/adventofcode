data = File.readlines(ARGV[0])

class Reindeer
  attr_reader :name, :speed, :flight_time, :rest_time

  FORMAT = %r[^(\w+) can fly (\d+) km/s for (\d+) seconds, but then must rest for (\d+) seconds]

  def initialize(description)
    @name, @speed, @flight_time, @rest_time = FORMAT.match(description).captures
    @speed       = @speed.to_i
    @flight_time = @flight_time.to_i
    @rest_time   = @rest_time.to_i
  end

  def cycle_time
    flight_time + rest_time
  end

  def distance_in(t)
    cycles, remainder = t.divmod(cycle_time)
    extra = [flight_time, remainder].min
    (cycles * flight_time + extra) * speed
  end

  def to_s
    "#{name}: #{speed} km/s for #{flight_time}s, rests #{rest_time}s"
  end
end

def leaders(reindeer, t)
  max_distance = reindeer.map { |deer| deer.distance_in(t) }.max
  reindeer.select { |deer| deer.distance_in(t) == max_distance }
end

reindeer = data.map { |line| Reindeer.new(line) }
race_time = ARGV[1].to_i

puts reindeer

points = Hash.new(0)
1.upto(race_time) do |t|
  deer = leaders(reindeer, t)
  deer.each { |d| points[d] += 1 }
end

puts points.map { |r, p| [p, r.to_s] }
winner = points.to_a.max_by(&:last).first
puts "Winner is #{winner.name}: #{points[winner]}"
