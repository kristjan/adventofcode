lines = File.readlines(ARGV[0]).each(&:strip!)

registers = {}
highest = 0

lines.each do |line|
  puts line
  reg, op, amount, cond_reg, comp, value =
    line.match(/(\w+) (inc|dec) (-?\d+) if (\w+) ([^ ]+) (-?\d+)/).captures
  registers[reg] ||= 0
  registers[cond_reg] ||= 0
  amount = amount.to_i
  value = value.to_i
  if (registers[cond_reg].send(comp, value))
    registers[reg] += amount * (op == 'inc' ? 1 : -1)
  end
  highest = registers[reg] if registers[reg] > highest
  highest = registers[cond_reg] if registers[cond_reg] > highest
end

state = registers.to_a.sort_by(&:last).map{|r| r.join("\t")}
puts state
puts
puts highest
