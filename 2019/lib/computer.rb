class Computer
  def initialize(program)
    @program = program.dup
    @ip = 0
  end

  def manual_input(value)
    @manual_input = value
  end


  def compute
    while true
      cmd = Cmd.new(@program, @program[@ip..(@ip+3)])
      cmd.input(@manual_input) if cmd.needs_input?
      result = cmd.run
      #puts @program.join(',')
      return result if cmd.exit?
      puts result if cmd.has_output?
      @ip = cmd.next_ip(@ip)
    end
  end
end

class Cmd
  POSITION = 0
  IMMEDIATE = 1

  def initialize(program, values)
    @program = program

    opcode, *@params = values
    opcode = opcode.to_s.rjust(5, ?0)
    @cmd = opcode[-2..-1].to_i
    @modes = opcode.chars[0...-2].map(&:to_i).reverse
  end

  def input(n)
    @input = n
  end

  def needs_input?
    @cmd == 3
  end

  def has_output?
    @cmd == 4
  end

  def value(n)
    case @modes[n]
    when POSITION then @program[@params[n]]
    when IMMEDIATE then @params[n]
    else raise "Invalid mode #{@modes[n]}"
    end
  end

  def exit?
    @cmd == 99
  end

  def run
    #puts [@cmd, @params, @modes].inspect
    case @cmd
    when 1
      @program[@params[2]] = value(0) + value(1)
    when 2
      @program[@params[2]] = value(0) * value(1)
    when 3
      @program[@params[0]] = if @input
                               @input
                             else
                               print '> '
                               $stdin.gets.to_i
                             end
    when 4
      value(0)
    when 5
      @next_ip = value(1) if value(0) != 0
    when 6
      @next_ip = value(1) if value(0) == 0
    when 7
      @program[@params[2]] = value(0) < value(1) ? 1 : 0
    when 8
      @program[@params[2]] = value(0) == value(1) ? 1 : 0
    when 99
      @program[0]
    else
      raise "Bad cmd #{@cmd}"
    end
  end

  def next_ip(cur_ip)
    @next_ip ? @next_ip : cur_ip + param_count
  end

  def param_count
    case @cmd
    when 1, 2, 7, 8 then 4
    when 3, 4 then 2
    when 5, 6 then 3
    else raise "Bad cmd #{@cmd}"
    end
  end
end
