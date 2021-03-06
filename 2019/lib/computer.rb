class Computer
  def initialize(program, pause_on_output = false)
    @program = program.dup
    @pause_on_output = pause_on_output
    @output = []
    @input = []
    @ip = 0
    @halted = false
    @relative_base = 0
  end

  def input(value)
    @input.push(value)
  end

  def output
    @output.shift
  end

  def output?
    @output.any?
  end

  def halted?
    @halted
  end

  def running?
    !@halted
  end

  def compute
    while true
      cmd = Cmd.new(@program, @program[@ip..(@ip+3)], @relative_base)
      cmd.input(@input.shift) if cmd.needs_input?
      result = cmd.run
      #puts @program.join(',')
      @output << result if cmd.has_output?
      if cmd.exit?
        @halted = true
        return result
      end
      @ip = cmd.next_ip(@ip)
      @relative_base = cmd.next_relative_base
      return if @pause_on_output && cmd.has_output?
    end
  end
end

class Cmd
  POSITION = 0
  IMMEDIATE = 1
  RELATIVE = 2

  def initialize(program, values, relative_base)
    @program = program
    program << 0 while @program.size < 100000
    @relative_base = relative_base

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
    when RELATIVE then @program[@relative_base + @params[n]]
    else raise "Invalid mode #{@modes[n]}"
    end
  end

  def storage_value(n)
    case @modes[n]
    when POSITION then @params[n]
    when IMMEDIATE then @params[n]
    when RELATIVE then @params[n] + @relative_base
    else raise "Invalid storage mode #{@modes[n]}"
    end
  end

  def exit?
    @cmd == 99
  end

  def run
    #puts [@cmd, @params, @modes, @relative_base].inspect
    case @cmd
    when 1
      @program[storage_value(2)] = value(0) + value(1)
    when 2
      @program[storage_value(2)] = value(0) * value(1)
    when 3
      raise 'No input' if @input.nil?
      index = storage_value(0)
      #puts "Storing input #{@input} to #{index}"
      @program[index] = @input
    when 4
      return value(0)
    when 5
      @next_ip = value(1) if value(0) != 0
    when 6
      @next_ip = value(1) if value(0) == 0
    when 7
      @program[storage_value(2)] = value(0) < value(1) ? 1 : 0
    when 8
      @program[storage_value(2)] = value(0) == value(1) ? 1 : 0
    when 9
      @relative_base += value(0)
    when 99
      return @program[0]
    else
      raise "Bad cmd #{@cmd}"
    end
    nil
  end

  def next_ip(cur_ip)
    @next_ip ? @next_ip : cur_ip + param_count
  end

  def next_relative_base
    @relative_base
  end

  def param_count
    case @cmd
    when 1, 2, 7, 8 then 4
    when 3, 4, 9 then 2
    when 5, 6 then 3
    else raise "Bad cmd #{@cmd}"
    end
  end
end
