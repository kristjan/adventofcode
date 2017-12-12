require 'json'

steps = ARGF.read.strip.split(',')

def distance(steps)
  counts = Hash.new(0)
  steps.each { |dir| counts[dir] += 1 }

  # Reduce opposites
  [
    %w[ne sw],
    %w[n s],
    %w[nw se]
  ].each do |a, b|
    a, b = b, a if counts[a] < counts[b]
    counts[a] -= counts[b]
    counts[b] = 0
  end

  # Simplify two-steps
  {
    %w[nw ne] => 'n',
    %w[nw s] => 'sw',
    %w[n se] => 'ne',
    %w[n sw] => 'nw',
    %w[ne nw] => 'n',
    %w[ne s] => 'se',
    %w[se n] => 'ne',
    %w[se sw] => 's',
    %w[s ne] => 'se',
    %w[s nw] => 'sw',
    %w[sw se] => 's',
    %w[sw n] => 'nw'
  }.each do |(a, b), c|
    while counts[a] > 0 && counts[b] > 0
      counts[a] -= 1
      counts[b] -= 1
      counts[c] += 1
    end
  end
  counts.values.inject(:+)
end

path = 0.upto(steps.size - 1).map do |i|
  distance(steps[0..i])
end

puts "Max: #{path.max}"
puts "Final: #{path.last}"
