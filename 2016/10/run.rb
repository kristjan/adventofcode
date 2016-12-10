input = File.read(ARGV[0]).split("\n")

class Bot
  attr_reader :chips

  def initialize
    @chips = []
  end

  def pop_high
    high.tap {|l| chips.delete(l)}
  end

  def pop_low
    low.tap {|l| chips.delete(l)}
  end

  def low
    chips.sort.first
  end

  def high
    chips.sort.last
  end
end

initial = input.select{|l| l =~ /^value/}
instructions = input - initial

bots = Hash.new { |h, k| h[k] = Bot.new }
output = Hash.new { |h, k| h[k] = Bot.new }

initial.each do |line|
  match = /value (\d+) goes to bot (\d+)/.match(line)
  bots[match[2].to_i].chips << match[1].to_i
end

puts bots

INSTRUCTION = /bot (\d+) gives low to (bot|output) (\d+) and high to (bot|output) (\d+)/

while instructions.any?
  line = instructions.shift

  giver_id, low_receiver, low_id, high_receiver, high_id =
    INSTRUCTION.match(line).to_a[1..-1]
  giver = bots[giver_id.to_i]

  if giver.chips.size < 2
    instructions.push(line)
    next
  end

  puts "17/61 is bot #{giver_id}" if giver.chips.sort == [17, 61]

  low_id = low_id.to_i
  high_id = high_id.to_i

  low_receiver = (low_receiver == 'bot' ? bots[low_id] : output[low_id])
  high_receiver = (high_receiver == 'bot' ? bots[high_id] : output[high_id])

  low_receiver.chips << giver.pop_low
  high_receiver.chips << giver.pop_high
end

puts [0, 1, 2].map{|i| output[i].chips.first}.inject(:*)
