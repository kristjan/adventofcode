rooms = File.read(ARGV[0]).split("\n")

def split(room)
  match = /([-a-z]+)-(\d+)\[(\w+)\]/.match(room)
  match.to_a[1..-1]
end

def sort_group(a, b)
  a_ch, a_count = a
  b_ch, b_count = b
  if a_count > b_count
    return -1
  elsif b_count > a_count
    return 1
  else
    return a_ch <=> b_ch
  end
end

real = rooms.select do |room|
  name, sector, check = split(room)
  hist = name.delete('-').chars.group_by(&:to_s).map{|c, g| [c, g.size]}
  top = hist.sort {|a, b| sort_group(a, b)}
  checksum = top.first(5).map(&:first).join
  checksum == check
end

sum = real.map do |room|
  name, sector, check = split(room)
  sector.to_i
end.inject(:+)

puts sum

def decrypt(name, sector)
  name.chars.map do |ch|
    alphabet = ('a'..'z').to_a
    case ch
    when '-' then ' '
    else
      alphabet.rotate!  until alphabet.first == ch
      alphabet.rotate!(sector.to_i)
      alphabet.first
    end
  end.join
end

real.each do |room|
  name, sector, check = split(room)
  puts [decrypt(name, sector), sector].inspect
end
