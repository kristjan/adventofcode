ids = File.readlines(ARGV[0]).map(&:strip)

def hist(s)
  Hash.new(0).tap do |h|
    s.chars.each {|ch| h[ch] += 1}
  end
end

def has_two?(s)
  hist(s).values.include?(2)
end

def has_three?(s)
  hist(s).values.include?(3)
end

twos = threes = 0

ids.each do |id|
  twos += 1 if has_two?(id)
  threes += 1 if has_three?(id)
end

puts twos, threes, twos * threes
