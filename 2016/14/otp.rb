require 'digest'

SALT = ARGV[0]
STRETCH = ARGV[1] == 'stretch'

HASHES = Hash.new do |h, k|
  hash = gen(SALT, k, STRETCH ? 2017 : 1)
  h[k] = {
    pad:   hash,
    three: runs(3, hash).first,
    fives: runs(5, hash)
  }
end

def gen(salt, j, rounds)
  str = "#{salt}#{j}"
  rounds.times do
    d = Digest::MD5.new
    d << str
    str = d.hexdigest
  end
  str
end

def runs(n, s)
  s.chars.each_cons(n).select do |set|
    set.uniq.size == 1
  end.map(&:first)
end

def key?(i)
  three = HASHES[i][:three]
  ((i + 1)...(i + 1000)).any? do |j|
    fives = HASHES[j][:fives]
    if fives.include?(three)
      puts "Match at #{j}"
      puts [HASHES[i][:pad], HASHES[j][:pad], three, fives, i, j].inspect
      true
    end
  end
end

pad = []
i = 0

while true
  print "#{i}\r" if i % 100 == 0
   if key?(i)
     pad << HASHES[i][:pad]
     puts "Found pad #{pad.size} at #{i}"
     break if pad.size == 64
   end
  i += 1
end

puts "Last at #{i}"
