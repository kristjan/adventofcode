data = File.readlines(ARGV[0]).each(&:strip!)

curstate = data.shift[-2]
iterations = data.shift.split(' ')[-2].to_i
data.shift # newline

rules = {}
tape = Hash.new(0)
pos = 0

while data.any?
  line = data.shift
  state = line[-2]

  2.times do
    line = data.shift
    curval = line[-2].to_i

    line = data.shift
    newval = line[-2].to_i

    line = data.shift
    move = line.split(' ').last.delete('.')

    line = data.shift
    newstate = line[-2]

    rules[state] ||= {}
    rules[state][curval] = {
      newval: newval,
      move: move,
      newstate: newstate
    }
  end
  data.shift # newline
end

iterations.times do |i|
  rule = rules[curstate]
  curval = tape[pos]
  action = rule[curval]
  tape[pos] = action[:newval]
  pos += action[:move] == 'right' ? 1 : -1
  curstate = action[:newstate]
end

puts tape.values.count{|v| v == 1}
