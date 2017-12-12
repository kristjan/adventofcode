require 'set'

input = File.readlines(ARGV[0]).each(&:strip!)

class Node
  attr_accessor :name, :neighbors

  def initialize(name)
    @name = name
    @neighbors = []
  end
end

pipes = {}

input.each do |line|
  name, rest = line.split('<->').each(&:strip!)
  name = name.to_i
  rest = rest.split(/,\s+/).map(&:to_i)
  pipes[name] ||= Node.new(name)
  rest.each do |n|
    pipes[n] ||= Node.new(n)
    pipes[name].neighbors << pipes[n]
    pipes[n].neighbors << pipes[name]
  end
end

friends = Set.new
seen = Set.new
left = [0]
while left.any?
  cur = left.shift
  friends << cur
  next if seen.include?(cur)
  seen << cur
  node = pipes[cur]
  left.concat(node.neighbors.map(&:name))
end

puts "Zero: #{friends.size}"

missing = pipes.keys - friends.to_a
groups = 1
while missing.any?
  groups += 1
  left = [missing.first]

  while left.any?
    cur = left.shift
    friends << cur
    next if seen.include?(cur)
    seen << cur
    node = pipes[cur]
    left.concat(node.neighbors.map(&:name))
  end

  missing = pipes.keys - friends.to_a
end

puts "Groups: #{groups}"
