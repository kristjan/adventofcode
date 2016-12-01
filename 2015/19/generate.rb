require 'set'

data = File.readlines(ARGV[0]).each(&:strip!)
data.reject!(&:empty?)
goal = data.pop

REACTIONS = data.map { |replacement| replacement.split(' => ')}

def produce_chemicals(molecule)
  elements = molecule.split(/(?=[A-Z])/)
  replaced = Set.new

  elements.each.with_index do |el, i|
    REACTIONS.each do |from, to|
      next unless from == el
      replaced << elements[0...i].join + to + elements[(i + 1)..-1].join
    end
  end

  replaced
end

Formula = Struct.new(:molecule, :steps)

queue = Queue.new
queue.push(Formula.new('e', 0))
seen = Set.new
max_steps = max_length = 0

until queue.empty? do
  current = queue.pop
  #puts "Reacting #{current.molecule}"
  if current.molecule == goal
    puts "Found the molecule in #{current.steps} steps"
    exit(0)
  end
  next if current.molecule.length >= goal.length
  if current.molecule.length > max_length
    puts "Length #{current.molecule.length}"
    max_length = current.molecule.length
  end
  if current.steps > max_steps
    puts "Step #{current.steps}"
    max_steps = current.steps
  end
  produce_chemicals(current.molecule).each do |molecule|
    next if seen.include?(molecule) || molecule.length > goal.length
    #puts "Enqueueing #{molecule}, #{current.steps + 1}"
    seen << molecule
    queue.push(Formula.new(molecule, current.steps + 1))
  end
end
