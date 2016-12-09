lines = File.read(ARGV[0]).split("\n")
recurse = ARGV[1] == 'recurse'

MARKER = /\((\d+)x(\d+)\)/

def decompress(str, recurse)
  total = 0

  while index = str =~ MARKER
    total += index
    match = $~

    str.slice!(0...(index + match[0].length))

    length, repeat = match[1..2].map(&:to_i)
    sub = str.slice!(0...length)

    total += repeat * (recurse ? decompress(sub, true) : length)
  end

  total += str.length
  total
end

lines.each do |line|
  puts [line, decompress(line.dup, recurse)].inspect
end
