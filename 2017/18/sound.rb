instructions = File.readlines(ARGV[0]).each(&:strip!)

REGISTERS = Hash.new(0)
pos = 0

def value(thing)
  if thing =~ /\A-?\d+\Z/
    thing.to_i
  else
    REGISTERS[thing]
  end
end

played = []

while pos >= 0 && pos < instructions.size
  inst = instructions[pos]
  parts = inst.split(' ')
  puts REGISTERS.inspect
  puts parts.join(' ')
  case parts[0]
  when 'set'
    REGISTERS[parts[1]] = value(parts[2])
    pos += 1
  when 'add'
    REGISTERS[parts[1]] += value(parts[2])
    pos += 1
  when 'mul'
    REGISTERS[parts[1]] *= value(parts[2])
    pos += 1
  when 'mod'
    REGISTERS[parts[1]] = value(parts[1]) % value(parts[2])
    pos += 1
  when 'snd'
    played << value(parts[1])
    pos += 1
  when 'rcv'
    REGISTERS[parts[1]] = played.last
    puts "Received #{played.last}"
    exit
    pos += 1
  when 'jgz'
    jump = if value(parts[1]) != 0
      value(parts[2])
    else
      1
    end
    puts "Jumping #{jump}"
    pos += jump
  end
end
