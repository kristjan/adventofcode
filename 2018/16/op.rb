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

OPS = [
  Addr,
  Addi,
  Mulr,
  Muli,
  Banr,
  Bani,
  Borr,
  Bori,
  Setr,
  Seti,
  Gtir,
  Gtri,
  Gtrr,
  Eqir,
  Eqri,
  Eqrr
]

class Example
  attr_reader :before, :cmd, :after

  def initialize(before, cmd, after)
    @before = clean(before)
    @after = clean(after)
    @cmd = cmd.split(' ').map(&:to_i)
  end

  def matching_ops
    OPS.select do |op_klass|
      op = op_klass.new(before)
      op.perform!(*cmd[1..-1])
      output = op.registers
      reg = cmd.last
      output[reg] == after[reg]
    end
  end

  private

  def clean(registers)
    eval(registers.split(': ').last)
  end
end

class Op

end

examples = []
while true
  before = input.shift
  if before.empty?
    input.shift # Blank line separating from program
    break
  end
  cmd, after = input.shift(2)
  examples << Example.new(before, cmd, after)
  input.shift # Blank line
end

program = input.map { |line| line.split(' ').map(&:to_i) }

puts(examples.count { |example| example.matching_ops.size >= 3 })

operations = Hash[Array.new(16) { |i| [i, OPS.dup] }]
examples.each do |example|
  matching = example.matching_ops
  opcode = example.cmd.first
  operations[opcode] &= matching
  if operations[opcode].size == 1
    ((0...16).to_a - [opcode]).each do |i|
      operations[i] -= operations[opcode]
    end
  end
end

operations.each { |opcode, ops| operations[opcode] = ops.first }
puts operations

registers = [0, 0, 0, 0]
program.each do |opcode, a, b, c|
  op_class = operations[opcode]
  op = op_class.new(registers)
  op.perform!(a, b, c)
  registers = op.registers
end

puts registers.inspect
