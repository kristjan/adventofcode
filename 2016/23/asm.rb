input = File.read(ARGV[0]).split("\n")

registers = {
  'a' => 12,
  'b' => 0,
  'c' => 0,
  'd' => 0,
}

ip = 0

#puts registers.inspect

def toggle(instructions, pos)
  puts "!! toggling #{pos} #{instructions[pos].inspect}"
  return unless instructions[pos]
  cmd, op1, op2 = instructions[pos].split(' ')
  count = [op1, op2].compact.size
  new_cmd = case count
            when 1
              if cmd == 'inc'
                "dec #{op1}"
              else
                "inc #{op1}"
              end
            when 2
              if cmd == 'jnz'
                "cpy #{op1} #{op2}"
              else
                "jnz #{op1} #{op2}"
              end
            end
  instructions[pos] = new_cmd
end

def reg?(op)
  %w[a b c d].include?(op)
end

def value(registers, op)
  reg?(op) ? registers[op] : op.to_i
end

while ip < input.size
  line = input[ip]
  cmd, op1, op2, op3 = line.split(' ')
  case cmd
  when 'nop'
    ip += 1
  when 'cpy'
    if reg?(op1)
      registers[op2] = registers[op1]
    else
      registers[op2] = op1.to_i
    end
    ip += 1
  when 'inc'
    registers[op1] += 1
    ip += 1
  when 'dec'
    registers[op1] -= 1
    ip += 1
  when 'jnz'
    if value(registers, op1) != 0
      ip += value(registers, op2)
    else
      ip += 1
    end
  when 'tgl'
    affected = ip + registers[op1]
    new_cmd = toggle(input, affected)
    puts [affected, new_cmd].inspect
    ip += 1
  when 'mul'
    registers[op3] = value(registers, op1) * value(registers, op2)
    registers[op1] = registers[op2] = 0
    ip += 1
  end
  puts
  puts [ip, cmd, op1, op2].inspect
  puts registers.inspect
end

#puts
puts 'Done'
puts registers.inspect
