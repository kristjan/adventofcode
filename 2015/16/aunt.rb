sue_data = File.readlines(ARGV[0])
forensics = File.readlines(ARGV[1])
RETROENCABLUATOR = !!ARGV[2]

class Sue
  ATTRIBUTES = %i[
    children
    cats
    samoyeds
    pomeranians
    akitas
    vizslas
    goldfish
    trees
    cars
    perfumes
  ]

  attr_reader :id, *ATTRIBUTES

  def initialize(memories)
    identifier, attributes = memories.split(':', 2)
    @id = /^Sue (\d+)/.match(identifier)[1].to_i
    attributes.split(',').each do |attribute|
      name, count = attribute.split(':').each(&:strip!)
      instance_variable_set "@#{name}", count.to_i
    end
  end
end

sues = sue_data.map { |memories| Sue.new(memories) }

clues = {}
forensics.each do |fact|
  name, count = fact.split(':').each(&:strip!)
  clues[name] = count.to_i
end

def matches?(clues, sue)
  clues.all? do |attribute, count|
    sue_attribute = sue.send(attribute)
    if sue_attribute.nil?
      true
    elsif RETROENCABLUATOR
      case attribute
      when 'cats', 'trees' then sue_attribute > count
      when 'pomeranians', 'goldfish' then sue_attribute < count
      else
        sue_attribute == count
      end
    else
      sue_attribute == count
    end
  end
end

suspects = sues.select { |sue| matches?(clues, sue) }
puts suspects.first.id
