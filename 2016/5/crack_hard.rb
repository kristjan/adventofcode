require 'digest'

PASSWORD_LENGTH = 8

door_id = ARGV[0]
start = (ARGV[0] || 0).to_i

password = '-' * 8
i = start

while password.include?('-')
  #puts i if i % 100000 == 0

  attempt = "#{door_id}#{i}"
  hash = Digest::MD5.new
  hash << attempt
  result = hash.hexdigest

  if result[0...5] == '00000'
    pos = Integer(result[5]) rescue nil
    if pos && pos < PASSWORD_LENGTH && password[pos] == '-'
      ch = result[6]
      password[pos] = ch
      puts [i, result, pos, ch, password].inspect
    end
  end

  i += 1
end

puts password
