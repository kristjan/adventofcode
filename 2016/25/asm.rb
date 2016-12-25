input = File.read(ARGV[0]).split("\n")
init = ARGV[1].to_i

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

BIN = /^(01)*0?$/

found = false
while !found
  registers = {
    'a' => init,
    'b' => 0,
    'c' => 0,
    'd' => 0,
  }
  out = ''
  ip = 0

  while ip < input.size && out.size < 10 && out =~ BIN
    line = input[ip]
    cmd, op1, op2, op3, op4 = line.split(' ')
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
      if op2
        registers[op1] += value(registers, op2)
      else
        registers[op1] += 1
      end
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
      toggle(input, affected)
      ip += 1
    when 'mul'
      registers[op3] = value(registers, op1) * value(registers, op2)
      registers[op1] = registers[op2] = 0
      ip += 1
    when 'div'
      top = value(registers, op1)
      bottom = value(registers, op2)
      registers[op3] = top / bottom
      registers[op4] = top.even? ? 2 : 1
      ip += 1
    when 'out'
      out << value(registers, op1).to_s
      ip += 1
    end
  end
  puts [init, out].inspect
  break if out =~ BIN
  init += 1
end
