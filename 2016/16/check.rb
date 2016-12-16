disk, length = ARGV.to_a
length = length.to_i

def invert(s)
  s.gsub!('0', '-')
  s.gsub!('1', '0')
  s.gsub!('-', '1')
  s
end

def expand(a)
  b = invert(a.reverse)
  "#{a}0#{b}"
end

def checksum(s)
  check = s.gsub(/../) do |part|
    part.chars.uniq.size == 1 ? '1' : '0'
  end
  check.size.even? ? checksum(check) : check
end

disk = expand(disk) while disk.size < length
disk = disk[0...length]
puts checksum(disk)
