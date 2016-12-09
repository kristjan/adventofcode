lines = File.read(ARGV[0]).split("\n")

def decompress(str)
  return 0 if str == ''
  total = 0
  input = str.chars

  while input.any?
    ch = input.shift
    if ch == '('
      length = ''

      while (ch = input.shift) != 'x'
        length << ch
      end
      length = length.to_i
      count = ''

      while (ch = input.shift) != ')'
        count << ch
      end
      count = count.to_i

      repeat = ''
      puts "Repeating #{repeat} (#{length}) x #{count}"
      length.times { repeat << input.shift }
      total += decompress(repeat) * count
    else
      total += 1
    end
  end

  total
end

lines.each do |line|
  puts [line, decompress(line)].inspect
end
