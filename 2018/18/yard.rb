input = File.read(ARGV[0])

class Yard
  attr_reader :yard

  def initialize(input)
    @yard = input.split("\n").map { |line| line.chars }
  end

  def tick!
    future = Array.new(yard.size) { Array.new(yard.first.size) }
    future.each.with_index do |row, i|
      row.each.with_index do |ch, j|
        future[i][j] = evolve(i, j)
      end
    end
    @yard = future
  end

  def open
    yard.flatten.count {|a| a == ?.}
  end

  def trees
    yard.flatten.count {|a| a == ?|}
  end

  def lumber
    yard.flatten.count {|a| a == ?#}
  end

  def to_s
    yard.map(&:join).join("\n")
  end

  private

  def evolve(i, j)
    case yard[i][j]
    when ?. then evolve_open(i, j)
    when ?| then evolve_tree(i, j)
    when ?# then evolve_lumber(i, j)
    end
  end

  def evolve_open(i, j)
    neighbors(i, j).count {|n| n == ?|} >= 3 ? ?| : ?.
  end

  def evolve_tree(i, j)
    neighbors(i, j).count {|n| n == ?#} >= 3 ? ?# : ?|
  end

  def evolve_lumber(i, j)
    trees = neighbors(i, j).count {|n| n == ?|}
    lumber = neighbors(i, j).count {|n| n == ?#}
    trees >= 1 && lumber >= 1 ? ?# : ?.
  end

  def neighbors(i, j)
    (-1..1).map do |di|
      (-1..1).map do |dj|
        next if di == 0 && dj == 0

        ni = i + di
        nj = j + dj
        next if ni < 0 || nj < 0 || ni >= @yard.size || nj >= @yard.first.size

        yard[ni][nj]
      end
    end.flatten
  end
end

history = {}

yard = Yard.new(input)
iterations = ARGV[1].to_i
iterations.times do |i|
  sig = yard.yard.flatten.join
  if history[sig]
    puts "Repeat at #{i}"
    puts "First occurence at #{history[sig]}"
    first = history[sig]
    cycle = i - first
    puts "Cycle is #{cycle}"
    puts "#{iterations} is #{first} + k*#{cycle}"
    k = (iterations - first) % cycle
    puts "k is #{k}"
    example = first + k
    puts "Example at #{example}"
    eyard, _eiter = history.detect { |_sig, iteration| iteration == example }
    counts = eyard.chars.group_by(&:itself).map do |type, group|
      [type, group.size]
    end
    counts = Hash[counts]
    puts counts.inspect
    puts counts[?|] * counts[?#]
    exit
  end
  history[sig] = i
  puts [i, yard.open, yard.trees, yard.lumber].inspect if i % 100 == 0
  yard.tick!
end

puts "Finished"
puts yard
puts [yard.open, yard.trees, yard.lumber].inspect
puts yard.trees * yard.lumber
