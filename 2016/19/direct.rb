# There's a pattern to the winning elf that lets us calculate their position
# directly.
#
# At an elf count that is a power of three, the last elf is the winner. As we
# add elves, the winner moves forward one (wrapping around the circle) until we
# get to the elf numbered the highest power of 3 that's less than our input.
# From there, the winner moves forward 2 at a time as new elves are added, until
# it converges on the next power of 3.
#
# ELVES WINNER
# 1     1
# 2     1
# 3     3
# 4     1
# 5     2
# 6     3
# 7     5
# 8     7
# 9     9
# 10    1
# 11    2
# 12    3
# 13    4
# 14    5
# 15    6
# 16    7
# 17    8
# 18    9
# 19    11
# 20    13
# 21    15
# 22    17
# 23    19
# 24    21
# 25    23
# 26    25
# 27    27
# 28    1
# 29    2
# ...

elf_count = ARGV[0].to_i

log_three = Math.log(elf_count, 3)
last_power = 3 ** (log_three.floor)
remaining = elf_count - last_power

if remaining == 0
  puts elf_count
elsif remaining < last_power
  puts remaining
else
  by_2 = remaining - last_power
  puts last_power + 2 * by_2
end
