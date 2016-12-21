input = ARGV[0]
instructions = File.read(ARGV[1]).split("\n")
unscramble = ARGV[2] == 'unscramble'

def swap_pos(input, x, y)
  input = input.dup
  input[x], input[y] = input[y], input[x]
  input
end

def swap_letter(input, x, y)
  input.tr("#{x}#{y}", "#{y}#{x}")
end

def rot(input, places)
  input.chars.rotate(places).join
end

def rot_pos(input, letter, dir)
  pos = input.index(letter)
  pos += 1 if pos >= 4
  pos += 1
  pos = -pos if dir == :right
  rot(input, pos)
end

def undo_rot_pos(input, letter)
  input.size.times do |i|
    try = rot(input, i)
    puts "Trying #{try} #{rot_pos(try, letter, :right)} #{input}"
    return try if rot_pos(try, letter, :right) == input
  end
end

def reverse_pos(input, x, y)
  input = input.dup
  input[x..y] = input[x..y].reverse
  input
end

def move(input, x, y)
  input = input.dup
  let = input[x]
  input[x] = ''
  input.insert(y, let)
  input
end

def scramble(input, instructions)
  instructions.each do |instruction|
    parts = instruction.split(' ')
    input = case instruction
            when /swap position/     then swap_pos(input, parts[2].to_i, parts[5].to_i)
            when /swap letter/       then swap_letter(input, parts[2], parts[5])
            when /rotate left/       then rot(input, parts[2].to_i)
            when /rotate right/      then rot(input, -parts[2].to_i)
            when /rotate based/      then rot_pos(input, parts[6], :right)
            when /reverse positions/ then reverse_pos(input, parts[2].to_i, parts[4].to_i)
            when /move position/     then move(input, parts[2].to_i, parts[5].to_i)
            end
    puts [instruction, input].inspect
  end
  input
end

def unscramble(input, instructions)
  puts "Backwards!"
  instructions.reverse.each do |instruction|
    parts = instruction.split(' ')
    input = case instruction
            when /swap position/     then swap_pos(input, parts[5].to_i, parts[2].to_i)
            when /swap letter/       then swap_letter(input, parts[2], parts[5])
            when /rotate left/       then rot(input, -parts[2].to_i)
            when /rotate right/      then rot(input, parts[2].to_i)
            when /rotate based/      then undo_rot_pos(input, parts[6])
            when /reverse positions/ then reverse_pos(input, parts[2].to_i, parts[4].to_i)
            when /move position/     then move(input, parts[5].to_i, parts[2].to_i)
            end
    puts [instruction, input].inspect
  end
  input
end

if unscramble
  puts unscramble(input, instructions)
else
  puts scramble(input, instructions)
end
