require 'set'

def element(item)
  item.to_s.split('_').first.to_sym
end

def chip?(item)
  item =~ /chip/
end

def generator?(item)
  item =~ /generator/
end

def deep_dup(state)
  Marshal.load(Marshal.dump(state))
end

def safe_floor?(floor)
  generators = floor.map { |thing| element(thing) if generator?(thing) }.compact
  return true if generators.empty?

  chips = floor.map { |thing| element(thing) if chip?(thing) }.compact
  return true if chips.empty?

  (chips - generators).empty?
end

def safe?(state)
  state.all? { |floor| safe_floor?(floor) }
end

def assemble?(state)
  state.last.size == THING_COUNT
end

class Item
  attr_accessor :steps, :floor, :state
  def initialize(steps, floor, state)
    @steps, @floor, @state = steps, floor, state
  end
end

def print(state)
  puts state.reverse.map(&:inspect)
end


def plan(initial_state, initial_floor)
  queue = Queue.new
  queue << Item.new(0, initial_floor, deep_dup(initial_state))
  seen = Set.new
  seen << [initial_floor, deep_dup(initial_state)]

  last_steps = -1

  while queue.size > 0
    current = queue.pop
    if current.steps > last_steps
      puts [
        "Floor: #{current.floor}",
        "Steps: #{current.steps}",
        "Queue: #{queue.size}",
        "Seen: #{seen.size}",
      ].join(', ')
      #print current.state
      last_steps = current.steps
    end

    min_occupied = current.state.index { |floor| floor.any? }

    items = current.state[current.floor]
    to_try = Set.new()
    items.each do |i|
      to_try << [i]
      items.each do |j|
        next if i == j
        to_try << [i, j].sort
      end
    end

    to_try.each do |take|
      [1, -1].each do |change|
        next_floor = current.floor + change
        if (min_occupied...current.state.size).include?(next_floor)
          next_state = deep_dup(current.state)
          next_state[current.floor] -= take
          next_state[next_floor] += take

          if assemble?(next_state)
            puts "Assembled: #{current.steps + 1}"
            exit
          end

          next_try = [next_floor, next_state]
          if !seen.include?(next_try) && safe?(next_state)
            seen << next_try
            queue << Item.new(current.steps + 1, next_floor, next_state)
          end
        end
      end
    end
  end
end

def floors(arr)
  arr.map(&Set.method(:new)).reverse # Put floors in machine order
end

SAMPLE = [
  [],
  [:lithium_generator],
  [:hydrogen_generator],
  [:hydrogen_chip, :lithium_chip],
]

FIRST_HALF = [
  [],
  [],
  [:polonium_chip, :promethium_chip],
  [:polonium_generator, :thulium_generator, :thulium_chip, :promethium_generator, :ruthenium_generator, :ruthenium_chip, :cobalt_generator, :cobalt_chip],
]

SECOND_HALF = [
  [],
  [],
  [:polonium_chip, :promethium_chip],
  [:polonium_generator, :thulium_generator, :thulium_chip, :promethium_generator, :ruthenium_generator, :ruthenium_chip, :cobalt_generator, :cobalt_chip, :elerium_generator, :elerium_chip, :dilithium_generator, :dilithium_chip],
]

SILLY_TRY = [
  [:thulium_generator, :thulium_chip],
  [],
  [],
  [:elerium_generator, :elerium_chip, :dilithium_generator, :dilithium_chip],
]

state = floors(SILLY_TRY)
THING_COUNT = state.map(&:size).inject(:+)

plan state, 3
