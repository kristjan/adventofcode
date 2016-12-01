instructions = File.readlines(ARGV[0]).each(&:strip!).map{|l| l.split(/,? /)}
output_register = ARGV[3]

memory = {
  'a' => Integer(ARGV[1]),
  'b' => Integer(ARGV[2])
}
ip = 0

until instructions[ip].nil?
  instruction, *args = instructions[ip]
  puts memory.inspect
  puts "#{ip}: #{instruction} #{args.inspect}"
  case instruction
  when 'hlf'
    register = args.first
    puts "\tHalving #{register}"
    memory[register] = memory[register] / 2
    ip += 1
  when 'tpl'
    register = args.first
    puts "\tTripling #{register}"
    memory[register] = memory[register] * 3
    ip += 1
  when 'inc'
    register = args.first
    puts "\tIncrementing #{register}"
    memory[register] += 1
    ip += 1
  when 'jmp'
    offset = Integer(args.first)
    puts "\tJumping #{offset}"
    ip += offset
  when 'jie'
    register, offset = args
    offset = Integer(offset)
    puts "\tJumping #{offset} if #{register} even"
    if memory[register].even?
      puts "\tEven"
      ip += offset
    else
      puts "\tOdd"
      ip += 1
    end
  when 'jio'
    register, offset = args
    offset = Integer(offset)
    puts "\tJumping #{offset} if #{register} is 1"
    if memory[register] == 1
      puts "\tOne"
      ip += offset
    else
      puts "\tNot"
      ip += 1
    end
  else
    raise "Illegal instruction #{instruction} #{args.inspect}"
  end
end

puts "Register #{output_register} is #{memory[output_register]}"
