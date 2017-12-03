data = File.readlines(ARGV[0]).map do |line|
  line.split(/\s+/).map(&:to_i)
end

sum = 0
data.each do |row|
  row.each.with_index do |a, i|
    row.each.with_index do |b, j|
      next if i == j
      if a % b == 0
        sum += a / b
      elsif b % a == 0
        sum += a / b
      end
    end
  end
end

puts sum
