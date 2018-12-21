require 'set'

seen = Set.new

DEBUG = false

def debug(*args)
  puts args if DEBUG
end

last = nil
r1 = r2 = r3 = r4 = r5 = 0
while true
  r2 = r4 | 65536
  r4 = 6152285

  checked = false
  while !checked
    debug '----------'
    debug [r1, r2, r4, r5].inspect
    r1 = r2 & 255
    debug [r1, r2, r4, r5].inspect
    r4 += r1
    debug [r1, r2, r4, r5].inspect
    r4 = r4 & 16777215
    debug [r1, r2, r4, r5].inspect
    r4 = r4 * 65899
    debug [r1, r2, r4, r5].inspect
    r4 = r4 & 16777215
    r1 = (r2 < 256) ? 1 : 0
    if r1 == 1
      if seen.include?(r4)
        puts "#{r4} has repeaeted"
        puts last
        exit
      end
      checked = true
      seen << r4
      last = r4
    else
      r2 /= 256
      debug [r1, r2, r4, r5].inspect
    end
  end
end
