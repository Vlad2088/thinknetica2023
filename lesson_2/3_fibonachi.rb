# Заполнить массив числами фибоначчи до 100
# Fn = Fn-1 + Fn-2
# n = 2

fibonachi = [0, 1]

loop do
  next_int = fibonachi[-1] + fibonachi[-2]
  break if next_int >= 100

  fibonachi << next_int
end

puts fibonachi