=begin
Сумма покупок. Пользователь вводит поочередно название товара, цену за единицу и кол-во купленного товара (может быть нецелым числом). Пользователь может ввести произвольное кол-во товаров до тех пор, пока не введет "стоп" в качестве названия товара. На основе введенных данных требуетеся:
  - Заполнить и вывести на экран хеш, ключами которого являются названия товаров, а значением  вложенный хеш, содержащий цену за единицу товара и кол-во купленного товара. Также вывести итоговую сумму за каждый товар.
  - Вычислить и вывести на экран итоговую сумму всех покупок в "корзине".
=end

hash = {}

input = ''
sum_name = 0
sum = 0

while(input != 'stop')
  puts 'Input product name'
  name = gets.to_s.chomp
  puts 'Input product price'
  price = gets.to_i
  puts 'Input product quantity'
  quantity = gets.to_f
  
  hash[name] = { price: price, quantity: quantity }
=begin
Если hash[name] есть, то надо задать вопрос:
 "Заменить значение", если нет, то задать вопрос "Добавить"
 Если  добавить, то 
 f = {:price, :quantity}
 f_1 = {:price, :quantity}
 f_2 = {:price, :quantity}
=end

  puts 'Continue?'
  puts 'Input ''stop'', for break enter, or press ''Enter'' to continue input'
  input = gets.to_s.chomp
end

hash.each do |name, hash|
  puts "#{name} = #{hash}"
  sum_name = hash[:price] * hash[:quantity]
  puts "Total #{name} = #{sum_name}"

  sum += hash[:price] * hash[:quantity]   
end

puts "Total amount = #{sum}"