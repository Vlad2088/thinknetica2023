$LOAD_PATH << './lib'

require 'station.rb'
require 'route.rb'
require 'train.rb'
require 'wagon.rb'
require 'cargo_train.rb'
require 'passenger_train.rb'
require 'cargo_wagon.rb'
require 'passenger_wagon.rb'


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
        "0 - выход"
      ]
      mode = gets.to_i
      case mode
        when 1 #cоздание
          creation
        when 2 #управление          
          control
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
        "4 - назначение позда на станцию",
        "5 - назначение поезду маршрут",
        "6 - управление вагонами", 
        "7 - управление маршрутом", 
        "8 - управление поездом",
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
        when 4 #Добавление поезда на станцию          
          add_train_in_station
        when 5 #Назначение маршрута поезду
          add_route
        when 6 #Добавление и удаление вагонов          
          add_and_delete_wagon
        when 7 #Управление маршрутом (добавлять и удалять станции)
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
        when 8 #Перемещение поезда по маршруту
          move_train
                 
      end
      break if input == 0  
    end

  end

  def creating_stations #Создание станции
    puts "Введите название станции"
    name = gets.chomp.capitalize
    station = @stations.find {|s| s.name == name}

    return if station 

    @stations << Station.new(name)
  end

  def creating_routes #Создание маршрута
    puts "Введите название маршрута (например: 'СПБ-Москва')"
    name_route = gets.chomp.downcase
      
    puts "Введите начальную станцию"
    starting_stations = gets.chomp.capitalize
    starting = @stations.find {|s| s.name == starting_stations}
      
    unless starting
      starting = Station.new(starting_stations)
      @stations << starting 
    end
      
    puts "Введите конечную станцию"
    end_stations = gets.chomp.capitalize
    final = @stations.find {|s| s.name == end_stations}
      
    unless final
      final = Station.new(end_stations)
      @stations << final
    end

    @routes << Route.new(name_route, starting, final)
  end

  def creating_trains #Создание поезда
    puts "Введите номер поезда"
    num = gets.chomp

    puts [
      "Выберете:", 
      "1 - Пассажирский поезд", 
      "2 - Грузовой поезд"
    ]
    n = gets.to_i
    case n
      when 1
        @trains << PassengerTrain.new(num, Train::PASSENGER_TYPE)
      when 2
        @trains << CargoTrain.new(num, Train::CARGO_TYPE)
      else
        puts "Выбрано не верное значение"
    end
  end

  def creating_wagons #Создание вагонов
     puts [
      "Выберете:", 
      "1 - Пассажирский вагон", 
      "2 - Грузовой вагон"
    ] 
     w = gets.to_i
     case w
       when 1
         @wagons << PassengerWagon.new
       when 2 
         @wagons << CargoWagon.new
     end
  end

  def list_station #Посмотр списка станций
    puts "Список станций:"
    @stations.each_with_index{|station, index| puts "#{index + 1} - #{station.name}"}
  end

  def list_train #Посмотр списка поездов на станции
    puts "Введите название станции"
    name = gets.chomp.capitalize  
    station = @stations.find {|s| s.name == name}
    if station
      station.print_trains
    else
      puts "Станция #{name} не найдена"
    end
  end

  def add_and_delete_wagon #Добавление и удаление вагонов
    puts "Введите номер поезда"
    num = gets.chomp
    train = @trains.find {|t| t.num == num}
    unless train
      puts "Поезд с номером #{num} не найден!"
      return
    end

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
        unless wagon
          puts "Подходящий вагон не найден с типом #{train.type}, создайте вагон!"
          return
        end

        @wagons.delete(wagon) if train.add_wagon(wagon)
      when 2 
        #Удаление 
        delete_wagon = train.delete_wagon 
        @wagons << delete_wagon if delete_wagon
    end
  end
  
  def add_route #Назначение маршрута поезду
    puts "Введите название маршрута"
    name_route = gets.chomp.downcase
    route = @routes.find {|r| r.name_route == name_route}
    unless route
      puts "Маршрут с названием #{name_route} не найден!"
      return
    end

    puts "Введите номер поезда"
    num = gets.chomp
    train = @trains.find {|t| t.num == num}
    if train
      train.add_route(route)
    else
      puts "Поезд с номером #{num} не найден!"
    end
    
  end 

  def add_stations_in_route #Управление маршрутом (добавлять станции)
    puts "Для добавления промежуточной станции введите название маршрута"
    name_route = gets.chomp.downcase
    route = @routes.find {|r| r.name_route == name_route}
    unless route
      puts "Маршрут с названием #{name_route} не найден!"
      return
    end

    puts "Введите промежуточную станцию"
    name = gets.chomp.capitalize
    station = @stations.find {|s| s.name == name}
      
    if station
      route.add_station(station)
    else
      puts "Станция #{name} не найдена, добавьте станцию в список!"
    end
       

  end

  def delete_stations_in_route #Управление маршрутом (удалять станции)
    puts "Для удаления промежуточной станции введите название маршрута"
    name_route = gets.chomp.downcase
    route = @routes.find {|r| r.name_route == name_route}
    unless route
      puts "Маршрут с названием #{name_route} не найден!"
      return
    end

    puts "Введите промежуточную станцию"
    name = gets.chomp.capitalize
    station = @stations.find {|s| s.name == name}
      
    if station
      route.delete_station(station)
    else
      puts "Станция #{name} в маршруте не найдена!"
    end
  end
  
  def move_train #Перемещение поезда по маршруту
    puts "Введите номер поезда"
    num = gets.chomp
    train = @trains.find {|t| t.num == num}
    unless train
      puts "Поезд с номером #{num} не найден!"
      return
    end

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
    num = gets.chomp
    train = @trains.find {|t| t.num == num}
    unless train
      puts "Поезд с номером #{num} не найден!"
      return
    end

    puts "Введите название станции"
    name = gets.chomp.capitalize  
    station = @stations.find {|s| s.name == name}
    if station
      station.add_train(train)
    else
      puts "Станция #{name} не найдена!"
    end
  end

  def print_free_wagons #Вывод смписка свободных вагонов
    puts "Имеющиеся свободные вагоны:"
    @wagons.each_with_index{|wagons, index| puts "#{index + 1} - #{wagons.type}"}
  end
end

App.new.run