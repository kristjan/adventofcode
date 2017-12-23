instructions = File.readlines(ARGV[0])
  .each {|l| l.gsub!(/#.*/, '')}
  .each(&:strip!)
  .map {|l| l.split(' ')}

class Program
  attr_accessor :id, :sent, :pos, :registers, :other, :queue, :instructions, :mults

  def initialize(id, instructions)
    @id = id
    @instructions = instructions
    @queue = Queue.new
    @sent = 0
    @pos = 0
    @registers = Hash.new(0)
    @mults = 0
  end

  def value(thing)
    if thing =~ /\A-?\d+\Z/
      thing.to_i
    else
      registers[thing]
    end
  end

  def step
    @pos += send(*current)
  end

  def current
    instructions[pos]
  end

  def nop
    1
  end

  def set(reg, val)
    registers[reg] = value(val)
    1
  end

  def add(reg, val)
    registers[reg] += value(val)
    1
  end

  def sub(reg, val)
    registers[reg] -= value(val)
    1
  end

  def mul(reg, val)
    registers[reg] *= value(val)
    @mults += 1
    1
  end

  def mod(reg, val)
    registers[reg] %= value(val)
    1
  end

  def snd(val)
    other.queue << value(val)
    @sent += 1
    1
  end

  def rcv(reg)
    if queue.empty?
      if other.waiting?
        puts "#{id}: #{sent}"
        puts "#{other.id}: #{other.sent}"
        exit 0
      else
        0
      end
    else
      registers[reg] = queue.pop
      1
    end
  end

  def jgz(reg, val)
    value(reg) > 0 ? value(val) : 1
  end

  def jnz(reg, val)
    jmp = value(reg) != 0 ? value(val) : 1
    jmp
  end

  def running?
    pos >= 0 && pos < instructions.size
  end

  def waiting?
    current.first == 'rcv' && queue.empty?
  end

  def to_s
    [id, pos, *current, queue.size, sent].inspect
  end
end

program = Program.new(0, instructions)

while program.running?
  program.step
end
puts program.mults
