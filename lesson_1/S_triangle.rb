=begin
Площадь треугольника. Площадь треугольника можно вычислить, зная его основание (a) и высоту (h) по формуле: 1/2*a*h. 
Программа должна запрашивать основание и высоту треугольника и возвращать его площадь.
=end

puts "Введите размер основания треугольника:"
base = gets.to_i

puts "Введите размер высоты треугольника:"
height = gets.to_i

s_triangle = base * height * 1 / 2

puts "Площадь треугольника = #{s_triangle}"