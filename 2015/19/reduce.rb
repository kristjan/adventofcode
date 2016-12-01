require 'set'

data = File.readlines(ARGV[0]).each(&:strip!)
data.reject!(&:empty?)
molecule = data.pop

REACTIONS = data.map { |replacement| replacement.split(' => ') }

steps = 0
while molecule != 'e'
  REACTIONS.each do |from, to|
    occurences = molecule.scan(to).size
    next if occurences == 0
    steps += occurences
    molecule.gsub!(to, from)
    puts "Replaced #{occurences} #{to} back to #{from}", molecule
  end
end
puts steps
