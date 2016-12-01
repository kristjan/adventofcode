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

def leader(reindeer, t)
  reindeer.max_by { |deer| deer.distance_in(t) }
end

reindeer = data.map { |line| Reindeer.new(line) }

race_time = ARGV[1].to_i
winner = leader(reindeer, race_time)

puts(
  reindeer.map { |deer| "#{deer.distance_in(race_time)} | #{deer}"}
)
puts "Winner is #{winner.name}: #{winner.distance_in(race_time)}km"
