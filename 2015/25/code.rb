# First in row N = first_in(N - 1) + N - 1
# Next after column N = N + (N + 1), N + 2, ...
#
INITIAL    = 20151125
MULTIPLIER = 252533
DIVISOR    = 33554393

row, col = ARGV.map(&:to_i)

FIRST_COLUMNS = Hash.new do |h, k|
  if k == 1
    h[k] = 1
  else
    h[k] = h[k - 1] + (k - 1)
  end
end

def column(row, col)
  val = FIRST_COLUMNS[row]
  increment = row + 1
  (col - 1).times do |c|
    val += increment
    increment += 1
  end
  val
end

value = column(row, col)
puts "Value in #{row}, #{col} is #{value}"

code = INITIAL
(value - 1).times do
  code *= MULTIPLIER
  _, code = code.divmod(DIVISOR)
end

puts "Code is #{code}"
