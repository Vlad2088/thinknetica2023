class Train 
    
    CARGO_TYPE = "cargo"
    PASSENGER_TYPE = "passenger"
    
    attr_reader :num, :type
    
    def initialize(num, type, wagons) #Имеет номер (произвольная строка) и тип (грузовой, пассажирский) и количество вагонов, эти данные указываются при создании экземпляра класса
        @num = num
        @type = type    
        @wagons = wagons
        @route
        @current_speed = 0
        @current_station
        puts "Поезд под номером #{num} создан."
    end
    
    def accelerate #Может набирать скорость
        @current_speed = @current_speed + rand(1..5)

        puts "Поезд набрал скорость: #{@current_speed} км/ч"
    end
    
    def stop #Может тормозить (сбрасывать скорость до нуля)
        @current_speed = [@current_speed - rand(1..5), 0].max

        puts "Поезд сбросил скорость: #{@current_speed} км/ч"
    end
    
    def speed #Может возвращать текущую скорость
        puts "Текущая скорость поезда: #{@current_speed} км/ч" 
    end
    
    def add_wagons  #Может прицеплять вагоны (по одному вагону за операцию, метод просто увеличивает количество вагонов). Прицепка вагонов может осуществляться только если поезд не движется.
        return  @wagons +=1 if @current_speed == 0 

        puts "Вагон невозможно дабавить, поезд в движении."
    end 
    
    def delete_wagons  #Может отцеплять вагоны (по одному вагону за операцию, метод просто уменьшает количество вагонов). Отцепка вагонов может осуществляться только если поезд не движется.
        return @wagons -=1 if @current_speed == 0 && @wagons > 0

        puts "Вагон невозможно отцепить, поезд в движении или отсутствуют вагоны."
    end 
    
    def wagons_quantity #Может возвращать количество вагонов
        puts "В поезде #{@wagons} вагонов"
    end
    
    def add_route(route) #Может принимать маршрут следования (объект класса Route). 
        @route = route 
        @current_station = route.stations[0] #При назначении маршрута поезду, поезд автоматически помещается на первую станцию в маршруте.
    end
    
    def move_next_station #Может перемещаться между станциями, указанными в маршруте. Вперед
        @current_station = route.stations[current_station_index + 1]
    end
    
    def move_previous_station #Может перемещаться между станциями, указанными в маршруте. Назад
        @current_station = route.stations[current_station_index - 1]
    end
    
    def current_station_index #Может перемещаться между станциями, указанными в маршруте.
        route.stations.each_with_index{|title, i| break i if @current_station == title}
    end
    
    def station_context #Возвращать предыдущую станцию, текущую, следующую, на основе маршрута
        {
            previous_station: route.stations[current_station_index - 1],
            current_station: @current_station,
            next_station: route.stations[current_station_index + 1]
        }
    end
end