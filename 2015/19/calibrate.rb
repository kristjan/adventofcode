require 'set'

data = File.readlines(ARGV[0]).each(&:strip!)
data.reject!(&:empty?)
molecule = data.pop

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

puts produce_chemicals(molecule).size
