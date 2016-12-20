input = File.read(ARGV[0])
  .split("\n")
  .map {|l| l.split("-").map(&:to_i)}
  .sort_by(&:first)

lowest = 0

while true
  changed = false
  input.each do |min, max|
    if (min..max).include?(lowest)
      changed = true
      lowest = max + 1
    end
  end
  break unless changed
end

puts lowest
