instructions = File.readlines(ARGV[0]).each(&:strip!).map {|l| l.split(' ')}

class Program
  attr_accessor :id, :sent, :pos, :registers, :other, :queue, :instructions

  def initialize(id, instructions)
    @id = id
    @instructions = instructions
    @queue = Queue.new
    @sent = 0
    @pos = 0
    @registers = Hash.new(0)
    @registers['p'] = id
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

  def set(reg, val)
    registers[reg] = value(val)
    1
  end

  def add(reg, val)
    registers[reg] += value(val)
    1
  end

  def mul(reg, val)
    registers[reg] *= value(val)
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

programs = Array.new(2) { |i| Program.new(i, instructions) }
programs.each.with_index { |p, i| p.other = programs[1 - i] }

current = programs[1]
loop do
  #puts ["\t" * current.id, current.registers.inspect, current].join("\t")

  current.step
  current = current.other if current.waiting?
end
