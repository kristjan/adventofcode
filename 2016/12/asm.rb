input = File.read(ARGV[0]).split("\n")

registers = {
  'a' => 0,
  'b' => 0,
  'c' => 0,
  'd' => 0,
}

ip = 0

#puts registers.inspect

while ip < input.size
  line = input[ip]
  cmd, op1, op2 = line.split(' ')
  case cmd
  when 'cpy'
    if registers.keys.include?(op1)
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
    if registers[op1] != 0
      ip += op2.to_i
    else
      ip += 1
    end
  end
  #puts
  #puts [ip, cmd, op1, op2].inspect
  #puts registers.inspect
end

#puts
puts 'Done'
puts registers.inspect
