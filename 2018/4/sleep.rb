require 'date'

class Guard
  attr_reader :dates, :id

  def initialize(id)
    @dates = {}
    @id = id
  end

  def on!(date)
    dates[date] ||= ['.'] * 60
  end

  def asleep!(date, hour, min)
    if hour == 23
      min = 0
      date += 1
    end
    dates[date] ||= ['.'] * 60
    dates[date][min..-1] = ['#'] * (60 - min)
  end

  def awake!(date, hour, min)
    if hour == 23
      min = 0
      date += 1
    end
    dates[date] ||= ['.'] * 60
    dates[date][min..-1] = ['.'] * (60 - min)
  end

  def total_minutes_asleep
    dates.map { |d, mins| mins.count {|m| m == '#'}}.inject(:+)
  end

  def most_likely_minute
    min, count = minute_frequency
    min
  end

  def highest_count
    min, count = minute_frequency
    count
  end

  def minute_frequency
    minutes = [0] * 60
    dates.each do |d, mins|
      mins.each.with_index do |v, i|
        minutes[i] += 1 if v == '#'
      end
    end
    max = minutes.max
    i = minutes.index(max)
    [i, max]
  end
end

guards = {}
current = nil

File.readlines(ARGV[0]).each do |line|
  date, time, msg = line.delete('[]').split(' ', 3)
  date = Date.parse(date)
  hour, min = time.split(':').map(&:to_i)
  case msg
  when /Guard/
    id = msg.gsub(/[^\d]/, '').to_i
    guards[id] ||= Guard.new(id)
    current = guards[id]
    current.on!(date)
  when /falls asleep/
    current.asleep!(date, hour, min)
  when /wakes up/
    current.awake!(date, hour, min)
  end
end

guards.each do |id, g|
  puts [id, g.total_minutes_asleep, g.most_likely_minute].inspect
#  g.dates.each do |d, v|
#    puts [d.to_s, v.join].inspect
#  end
end

puts '==='

sleeper = guards.values.sort_by(&:total_minutes_asleep).last
puts [sleeper.id, sleeper.total_minutes_asleep, sleeper.most_likely_minute, sleeper.id * sleeper.most_likely_minute].inspect

puts '==='

consistent = guards.values.sort_by do |g|
  g.highest_count
end.last

puts [consistent.id, consistent.total_minutes_asleep, consistent.most_likely_minute, consistent.id * consistent.most_likely_minute].inspect
