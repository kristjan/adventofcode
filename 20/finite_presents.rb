require 'set'
min_presents = ARGV[0].to_i

def divisors(n)
  Set.new.tap do |divisors|
    (1..(Math.sqrt(n).floor)).each do |i|
      if n % i == 0
        divisors << i     if n <= 50 * i
        divisors << n / i if n <= 50 * n / i
      end
    end
  end
end

(1..(min_presents / 10)).detect do |n|
  count = divisors(n).inject(:+) * 11
  if count >= min_presents
    puts "House #{n}: #{count}"
    exit
  end
end
