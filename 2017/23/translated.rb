b = 108400
c = 125400

h = 0

while b <= c
  puts b
  f = 1
  d = 2

  while d <= b
    e = 2
    while e <= b
      f = 0 if d * e == b
      break if d * e >= b
      e += 1
    end
    d += 1
    break if f == 0
  end

  h += 1 if f == 0
  b += 17
end
puts h
