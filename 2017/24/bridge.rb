require 'set'

parts = File.readlines(ARGV[0])
  .each(&:strip!)
  .map { |l| l.split('/').map(&:to_i) }

def build(bridge, tail, parts, bridges)
  bridges << bridge
  return if parts.empty?

  parts.each do |part|
    case
    when part.first == tail
      build(bridge + [part], part.last, parts - [part], bridges)
    when part.last == tail
      build(bridge + [part], part.first, parts - [part], bridges)
    end
  end
end

bridges = Set.new
build([], 0, parts, bridges)
puts "Bridges: #{bridges.size}"

strongest = bridges.map { |b| b.flatten.inject(:+) }.compact.max
puts "Strongest: #{strongest}"

longest = bridges.map(&:size).max
puts "Longest: #{longest}"

strengths = bridges
  .select { |b| b.size == longest }
  .map { |b| b.flatten.inject(:+) }
longest_strength = strengths.max
puts "Longest Strength: #{longest_strength}"
