class Station 

    attr_reader :name, :train
    
    def initialize(name) #Имеет название, которое указывается при ее создании-
        @name = name
        @train_in_station = []
        puts "Станция #{name} создана."
    end
    
    def add_train(train) #Может принимать поезда (по одному за раз)
    
        @train_in_station << train
        puts "На станции #{@name} принят #{train.num} поезд."
    
    end
    
    def all_list_train #Может возвращать список всех поездов на станции, находящиеся в текущий момент
        puts "На станции находятся поезда:"
        @train_in_station.each{ |train| puts "#{train.num}" }
     
    end
    
    def trains_by_type(train_type) #Может возвращать список поездов на станции по типу (см. ниже): кол-во грузовых, пассажирских
        
        @train_in_station.select { |train| train.type == train_type }
    
    end
    
    def cargo_trains_count
    
        trains_by_type(Train::CARGO_TYPE).size
     
    end
    
    def passenger_trains_count
    
        trains_by_type(Train::PASSENGER_TYPE).size
     
    end
    
    def delete_trains(train) #Может отправлять поезда (по одному за раз, при этом, поезд удаляется из списка поездов, находящихся на станции).
    
        @train_in_station.delete(train)
        puts "Со станции #{@name} убыл #{train.num} поезд."
    
    end
    
    end
    
    class Route
    
    attr_reader :stations
    
    def initialize(starting_stations, end_stations) #Имеет начальную и конечную станцию, а также список промежуточных станций. Начальная и конечная станции указываютсся при создании маршрута, а промежуточные могут добавляться между ними.
        
        @stations = [starting_stations, end_stations]
        puts "Маршрут от станции #{starting_stations} до станции #{end_stations} создан."
    end
    
    def add_stations(new_stations) #Может добавлять промежуточную станцию в список
       
        @stations.insert(-2, new_stations)
        puts "Промежуточная станция #{new_stations} добавлена"
    end
    
    def stations_list #Может выводить список всех станций по-порядку от начальной до конечной
        
        puts "Маршрут поезда:"
        @stations.each_with_index{|station, index| puts "#{index + 1} - #{station}"}
    end
    
    def remove_station(name_st) #Может удалять промежуточную станцию из списка
        
        if [@stations.first, @stations.last].include? name_st
            puts "Начальную и конечную станцию удалить невозжожно"
        else @stations.delete(name_st)
            puts "Станция удалена"
        end
    end
    
    end
    
    class Train 
    
    CARGO_TYPE = "cargo"
    PASSENGER_TYPE = "passenger"
    
    attr_reader :num, :type, :wagons, :route
    
    def initialize(num, type, wagons) #Имеет номер (произвольная строка) и тип (грузовой, пассажирский) и количество вагонов, эти данные указываются при создании экземпляра класса
        
        @num = num
        @type = type    
        @wagons = wagons
        @route
        @current_speed = 0
        @current_station
        puts "Поезд под номером #{num} создан."
    end
    
    def acceleration_train #Может набирать скорость
        
        @current_speed = @current_speed + rand(1..5)

        puts "Поезд набрал скорость: #{@current_speed} км/ч"
    end
    
    def stop_train #Может тормозить (сбрасывать скорость до нуля)
        
        if @current_speed >= 5
            @current_speed = @current_speed - rand(1..5)
        else 
            @current_speed = 0
        end
        puts "Поезд сбросил скорость: #{@current_speed} км/ч"
    end
    
    def speed_train #Может возвращать текущую скорость
        
        puts "Текущая скорость поезда: #{@current_speed} км/ч" 
    end
    
    def add_wagons  #Может прицеплять вагоны (по одному вагону за операцию, метод просто увеличивает количество вагонов). Прицепка вагонов может осуществляться только если поезд не движется.
       
        if @current_speed == 0
            @wagons +=1
            puts "Вагон добавлен"
        else
            puts "Вагон невозможно дабавить, поезд в движении."
        end        
    end 
    
    def remove_wagons  #Может отцеплять вагоны (по одному вагону за операцию, метод просто уменьшает количество вагонов). Отцепка вагонов может осуществляться только если поезд не движется.
       
        if @current_speed == 0 && @wagons > 0
            @wagons -=1
            puts "Вагон отцеплен"
        else
            puts "Вагон невозможно отцепить, поезд в движении или отсутствуют вагоны."
        end        
    end 
    
    def quantity_wagon #Может возвращать количество вагонов
        
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