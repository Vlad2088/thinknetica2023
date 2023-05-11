$LOAD_PATH << './lib'

require 'station.rb'
require 'route.rb'
require 'train.rb'
require 'wagon.rb'
require 'cargo_train.rb'
require 'passenger_train.rb'
require 'cargo_wagon.rb'
require 'passenger_wagon.rb'
require 'manufacturer.rb'
require 'instance_counter.rb'
require 'validation_error.rb'


class App

  def initialize
    @stations =[]
    @trains = []
    @wagons = []
    @routes = []
  end

  def run
    loop do
      puts [
        "Выберете:", 
        "1 - режим создания", 
        "2 - режим управления", 
        "3 - режим просотра количества объектов",
        "0 - выход"
      ]
      mode = gets.to_i
      case mode
        when 1 #cоздание
          creation
        when 2 #управление          
          control
        when 3
          station_instances
          route_instances
          train_instances
          wagon_instances
      end
      break if mode == 0  
    end
  end

  def creation #cоздание
    loop do
      puts [
        "Выберете:", 
        "1 - создание станции", 
        "2 - создание маршрута", 
        "3 - создание поезда",
        "4 - Создание вагонов", 
        "0 - выход в предыдущее меню"
      ]
    
      input =  gets.to_i
      case input
        when 1 #Создание станции
          creating_stations
        when 2 #Создание маршрута
          creating_routes      
        when 3 #Создание поезда
          creating_trains
        when 4 #Создание вагонов
          creating_wagons
      end
      break if input == 0  
    end
      
  end

  def control #управление
    loop do
      puts [
        "Выберете:", 
        "1 - вывод списка станций", 
        "2 - вывод списка поездов на станции",
        "3 - вывод списка свободных вагонов", 
        "4 - вывод информации по поезду",
        "5 - назначение позда на станцию",
        "6 - назначение поезду маршрут", 
        "7 - управление вагонами", 
        "8 - управление маршрутом",
        "9 - управление бронирование мест",
        "10 - управление поездом",
        "0 - выход в предыдущее меню"
      ]
      input =  gets.to_i
      case input
        when 1 #Посмотр списка станций
          list_station
        when 2 #Посмотр списка поездов на станции          
          list_train
        when 3 #Вывод списка свободных вагонов
          print_free_wagons
        when 4 #вывод информации по поезду
          info_train
        when 5 #Добавление поезда на станцию     
          add_train_in_station
        when 6 #Назначение маршрута поезду
          add_route
        when 7  #Добавление и удаление вагонов          
          add_and_delete_wagon
        when 8 #Управление маршрутом (добавлять и удалять станции)
          puts [
            "Выберете:", 
            "1 - добавить станцию к маршруту", 
            "2 - удалить станцию из маршрута"
          ] 
          s = gets.to_i
          case s
            when 1
              add_stations_in_route
            when 2 
              delete_stations_in_route
          end
        when 9 #управление бронированием мест
          control_booking  
        when 10  #управление поездом
          move_train       
      end
      break if input == 0  
    end

  end

  def creating_stations #Создание станции
    begin
      puts "Введите название станции (например: 'Moscow или SPB')."
      name = gets.chomp.capitalize
      station = find_station(name)

      return if station 

      @stations << Station.new(name)
      puts "Станция #{name} создана."
    rescue ValidationError => e
      puts "#{e.message}. Вы ввели: #{e.error}"
      retry
    end
  end

  def creating_routes #Создание маршрута
    begin
      puts "Введите название маршрута (например: 'SPB-Moscow')"
      name_route = gets.chomp.downcase
      
      puts "Введите начальную станцию"
      starting_stations = gets.chomp.capitalize
      starting = find_station(starting_stations)
      
      unless starting
        puts "Станция #{starting_stations} не найдена, создайте станцию."
        return
      end
      
      puts "Введите конечную станцию"
      end_stations = gets.chomp.capitalize
      final = find_station(end_stations)
      
      unless final
        puts "Станция #{end_stations} не найдена, создайте станцию."
        return
      end

      @routes << Route.new(name_route, starting, final)
      puts "Маршрут #{name_route} от станции #{starting.name} до станции #{final.name} создан."
    rescue ValidationError => e
      puts "#{e.message}. Вы ввели: #{e.error}"
      retry
    end
  end

  def creating_trains #Создание поезда
    begin
      puts "Введите номер поезда (например: '111-QQ')"
      num = gets.chomp.upcase

      puts [
        "Выберете:", 
        "1 - Пассажирский поезд", 
        "2 - Грузовой поезд"
      ]
      n = gets.to_i

      puts "Добавьте производителя поезда (например: 'Alstom')."
      manufacturer = gets.chomp.capitalize

      case n
        when 1
          train = PassengerTrain.new(num, manufacturer, Train::PASSENGER_TYPE)
        when 2
          train = CargoTrain.new(num, manufacturer, Train::CARGO_TYPE)
        else
          puts "Выбрано не верное значение"
      end

      @trains << train

      puts "Поезд под номером #{num} создан, производитель: #{manufacturer}"
    rescue ValidationError => e
      puts "#{e.message}. Вы ввели: #{e.error}"
      retry
    end
  end

  def creating_wagons #Создание вагонов
    begin
      puts [
        "Выберете:", 
        "1 - Пассажирский вагон", 
        "2 - Грузовой вагон"
      ] 
      w = gets.to_i

      puts "Добавьте производителя вагона (например: 'Fesco')."
      manufacturer = gets.chomp.capitalize

      puts "Веведите вместимость вагона(для пассажиркского кол-во мест, а для грузового объем)."
      capacity = gets.to_i

      case w
        when 1
          wagon = PassengerWagon.new(capacity, manufacturer)
        when 2 
          wagon = CargoWagon.new(capacity, manufacturer)
      end

      @wagons << wagon

      puts "Вагон типа #{wagon.type} создан, производитель: #{manufacturer}, вместимостью #{capacity}"   
    rescue ValidationError => e
      puts "#{e.message}. Вы ввели: #{e.error}"
      retry
    end
  end

  def list_station #Посмотр списка станций
    puts "Список станций:"
    Station.all.each_with_index{|station, index| puts "#{index + 1} - #{station.name}"}
  end

  def info_train #Посмотр информации поезда

    puts "Введите номер поезда"
    num = gets.chomp.upcase
    train = find_train(num)

    return unless train
    
    puts "Поезд #{train.num}, найден в системе."
    puts "Поезду присвоен маршрут '#{train.route&.name_route || 'Маршрут поезду не назначен!'}'." 
    
    train.each_wagons do |wagon|
      puts "Номер вагона: #{wagon.number}, тип вагона: #{wagon.type}, Свобоного места(объема): #{wagon.remaining_seat}, Зарезервированного места(объема): #{wagon.occupied_place}"
    end
  end

  def list_train #Посмотр списка поездов на станции
    puts "Введите название станции"
    name = gets.chomp.capitalize  
    station = find_station(name)

    unless station
      puts "Станция #{name} не найдена"
      return
    end
    
    puts "На станции #{name} находятся поезда:"
    #station.print_trains
    station.each_trains do |train|
      puts "Номер поезда: #{train.num}, тип поезда: #{train.type}, количество вагонов #{train.wagon_size}"
    end
  end

  def add_and_delete_wagon #Добавление и удаление вагонов
    puts "Введите номер поезда"
    num = gets.chomp.upcase
    train = find_train(num)
    
    return unless train

    puts [
      "Выберете:", 
      "1 - добавить вагон", 
      "2 - удалить вагон"
    ] 
    w = gets.to_i
    case w
      when 1
        #Добавление 
        wagon = @wagons.find {|w| w.type == train.type}
        wagon.number = train.wagon_size + 1
        unless wagon
          puts "Подходящий вагон не найден с типом #{train.type}, создайте вагон!"
          return
        end

        @wagons.delete(wagon) if train.add_wagon(wagon)
        puts "Вагон № #{wagon.number} успешно добавлен."
      when 2 
        #Удаление 
        delete_wagon = train.delete_wagon 
        @wagons << delete_wagon if delete_wagon
        puts "Вагон успешно отцеплен."
    end
  end
  
  def add_route #Назначение маршрута поезду
    puts "Введите название маршрута"
    name_route = gets.chomp.downcase
    route = find_route(name_route)

    return unless route

    puts "Введите номер поезда"
    num = gets.chomp.upcase
    train = find_train(num)
    
    return unless train
      
    train.add_route(route)   
    puts "Маршрут принят."
  end 

  def add_stations_in_route #Управление маршрутом (добавлять станции)
    puts "Для добавления промежуточной станции введите название маршрута"
    name_route = gets.chomp.downcase
    route = find_route(name_route)

    return unless route

    puts "Введите промежуточную станцию"
    name = gets.chomp.capitalize
    station = find_station(name)

    unless station
      puts "Станция #{name} не найдена, добавьте станцию в список!"
      return
    end
      
    route.add_station(station)
    puts "Промежуточная станция #{name} добавлена"
  end

  def delete_stations_in_route #Управление маршрутом (удалять станции)
    puts "Для удаления промежуточной станции введите название маршрута"
    name_route = gets.chomp.downcase
    route = find_route(name_route)

    return unless route

    puts "Введите промежуточную станцию"
    name = gets.chomp.capitalize
    station = find_station(name)

    unless station
      puts "Станция #{name} в маршруте не найдена!"
      return
    end
      
    if route.delete_station(station)
      puts "Станция удалена"
    else
      puts "Начальную и конечную станцию удалить невозжожно"
    end
  end
  
  def move_train #Перемещение поезда по маршруту
    puts "Введите номер поезда"
    num = gets.chomp.upcase
    train = find_train(num)
    
    return unless train

    loop do
      puts [
        "Выберете:", 
        "1 - Двигаться вперед", 
        "2 - Двигаться назад", 
        "3 - Выввести текущую и ближайшие станции", 
        "0 - выход"
      ]
      move = gets.to_i
      case move
      when 1
        train.move_next_station
      when 2
        train.move_previous_station
      when 3
        puts [
          "Предыдущая станция - #{train.station_context[:previous_station]}", 
          "Текущая станция - #{train.station_context[:current_station]}",
          "Следующая станция - #{train.station_context[:next_station]}"
        ]
      end
      break if move == 0  
    end
  end
  
  def add_train_in_station #Добавление поезда на станцию 
    puts "Введите номер поезда"
    num = gets.chomp.upcase
    train = find_train(num)
    
    return unless train

    puts "Введите название станции"
    name = gets.chomp.capitalize  
    station = find_station(name)

    unless station
      puts "Станция #{name} не найдена!"
      return
    end

    station.add_train(train)
    puts "На станции #{name} принят #{train} поезд."
  end

  def print_free_wagons #Вывод списка свободных вагонов
    puts "Имеющиеся свободные вагоны:"
    @wagons.each_with_index{|wagons, index| puts "#{index + 1} - #{wagons.type}"}
  end

  def control_booking #бронирование мест
    puts "Введите номер поезда"
    num = gets.chomp.upcase
    train = find_train(num)
    
    return unless train
    return unless train.check_occupied_place
    
    if train.type == Train::PASSENGER_TYPE

      puts "Забронировать место? (1-да или 2-нет)"
      input = gets.to_i
      if input == 1
        wagon = train.wagon.find {|w| w.remaining_seat > 0}
        wagon.take_the_place_of
        puts "Место забронировано!"
      else 
        puts "Место не забронировано!"
        return
      end
    else 
      puts "Введите объем груза, который хоите отправить"
      volume = gets.to_i
      wagon = train.wagon.find {|w| w.remaining_seat >= volume}

      return puts "Ваш объем слишком большой, попробуйте его разделить!" unless wagon

      wagon.take_the_place_of(volume)
      puts "Место забронировано!"
    end
    
  end

  def find_train(num)
    train = @trains.find {|t| t.num == num}
    
    unless train
      puts "Поезд с номером #{num} не найден!"
      return
    end

    train
  end

  def find_station(name)
    station = @stations.find {|s| s.name == name}

    station
  end

  def find_route(name_route)
    route = @routes.find {|r| r.name_route == name_route}
   
    unless route
      puts "Маршрут с названием #{name_route} не найден!"
      return
    end

    route
  end


  def station_instances
    puts "Создано станций: #{Station.instance}"
  end

  def route_instances
    puts "Создано маршрутов: #{Route.instance}"
  end

  def wagon_instances
    puts "Создано пассажирских вагонов: #{PassengerWagon.instance}"
    puts "Создано грузовых вагонов: #{CargoWagon.instance}"
  end

  def train_instances
    puts "Создано пассажирскийх поездов: #{PassengerTrain.instance}"
    puts "Создано грузовых поездов: #{CargoTrain.instance}"
  end
end

App.new.run