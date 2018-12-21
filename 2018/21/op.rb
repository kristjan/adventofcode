require 'set'

input = File.readlines(ARGV[0]).each(&:strip!)

class Op
  attr_reader :registers

  def initialize(registers)
    @registers = registers.dup
  end

  def perform!(a, b, save)
    registers[save] = run(a, b)
  end

  def register(r)
    registers[r]
  end

  def immediate(i)
    i
  end

  def nop(n)
    nil
  end
end

class Addr < Op
  def run(a, b)
    registers[a] + registers[b]
  end
end

class Addi < Op
  def run(a, b)
    registers[a] + b
  end
end

class Mulr < Op
  def run(a, b)
    registers[a] * registers[b]
  end
end

class Muli < Op
  def run(a, b)
    registers[a] * b
  end
end

class Banr < Op
  def run(a, b)
    registers[a] & registers[b]
  end
end

class Bani < Op
  def run(a, b)
    registers[a] & b
  end
end

class Borr < Op
  def run(a, b)
    registers[a] | registers[b]
  end
end

class Bori < Op
  def run(a, b)
    registers[a] | b
  end
end

class Setr < Op
  def run(a, b)
    registers[a]
  end
end

class Seti < Op
  def run(a, b)
    a
  end
end

class Gtir < Op
  def run(a, b)
    a > registers[b] ? 1 : 0
  end
end

class Gtri < Op
  def run(a, b)
    registers[a] > b ? 1 : 0
  end
end

class Gtrr < Op
  def run(a, b)
    registers[a] > registers[b] ? 1 : 0
  end
end

class Eqir < Op
  def run(a, b)
    a == registers[b] ? 1 : 0
  end
end

class Eqri < Op
  def run(a, b)
    registers[a] == b ? 1 : 0
  end
end

class Eqrr < Op
  def run(a, b)
    registers[a] == registers[b] ? 1 : 0
  end
end

program = input.map do |line|
  op, a, b, c = line.split(' ')
  a, b, c = [a, b, c].map(&:to_i)
  [op, a, b, c]
end

ipline = program.shift
ipr = ipline[1]

init = ARGV[1].to_i
registers = [init, 0, 0, 0, 0, 0]
count = 0
while registers[ipr] >= 0 && registers[ipr] < program.size
  opcode, a, b, c = program[registers[ipr]]
  #puts [opcode, a, b, c, '|', *registers].map(&:to_s).map{|el| el.rjust(8, ' ')}.join(',')
  if opcode == 'eqrr'
    puts "----- #{registers[4]} would exit"
  end
  op_class = Op.const_get(opcode.capitalize)
  op = op_class.new(registers)
  op.perform!(a, b, c)
  registers = op.registers
  registers[ipr] += 1
  count += 1
end

puts '======='

puts [init, count].inspect
