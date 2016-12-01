require 'digest'

key = ARGV[0]
difficulty = ARGV[1].to_i
prefix = '0' * difficulty

n = 0
begin
  n += 1
  md5 = Digest::MD5.new
  md5.update "#{key}#{n}"
  hash = md5.hexdigest
end until hash[0...difficulty] == prefix

puts n, hash
