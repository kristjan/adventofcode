ids = File.readlines(ARGV[0]).map(&:strip)

def pairs(a, b)
  a.chars.zip(b.chars)
end

def off_by_one?(a, b)
  pairs(a, b).count { |i, j| i == j } == a.size - 1
end

def common(a, b)
  pairs(a, b).map do |i, j|
    i if i == j
  end.join
end

ids.each do |id|
  ids.each do |jd|
    next if id == jd
    if off_by_one?(id, jd)
      puts common(id, jd)
      exit
    end
  end
end
