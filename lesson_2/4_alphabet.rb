=begin
 Заполнить хеш гласными буквами, где значением будет являтся порядковый номер буквы в алфавите (a - 1).
=end

n = ('a'..'z').to_a.each_with_object({}).with_index(1) { |(char, hash), i| char =~ /[aeiou]/ ? hash[i] = char : hash}

puts n