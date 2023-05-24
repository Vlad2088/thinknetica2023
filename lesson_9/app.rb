$LOAD_PATH << './lib'

require 'station'
require 'route'
require 'train'
require 'wagon'
require 'cargo_train'
require 'passenger_train'
require 'cargo_wagon'
require 'passenger_wagon'
require 'manufacturer'
require 'instance_counter'
require 'validation_error'
require 'accessors'
require 'validation'

class App
  def initialize
    @stations = []
    @trains = []
    @wagons = []
    @routes = []
  end

  def run
    loop do
      puts [
        'You are taking:',
        '1 - creation mode',
        '2 - control mode',
        '3 - view mode of the number of objects',
        '0 - exit'
      ]
      mode = gets.to_i
      case mode
      when 1
        creation
      when 2
        control
      when 3
        station_instances
        route_instances
        train_instances
        wagon_instances
      end
      break if mode.zero?
    end
  end

  def creation
    loop do
      puts [
        'You are taking:',
        '1 - creation of a station',
        '2 - route creation',
        '3 - creating a train',
        '4 - creation of wagons',
        '0 - exit to previous menu'
      ]

      input = gets.to_i
      case input
      when 1
        creating_stations
      when 2
        creating_routes
      when 3
        creating_trains
      when 4
        creating_wagons
      end
      break if input.zero?
    end
  end

  def control
    loop do
      puts [
        'You are taking:',
        '1 - list of stations',
        '2 - displaying a list of trains at a station',
        '3 - displaying a list of free wagons',
        '4 - train information output',
        '5 - appointment late to the station',
        '6 - train route assignment',
        '7 - wagon management',
        '8 - route control',
        '9 - seat booking management',
        '10 - train control',
        '0 - exit to previous menu'
      ]
      input = gets.to_i
      case input
      when 1
        list_station
      when 2
        list_train
      when 3
        print_free_wagons
      when 4
        info_train
      when 5
        add_train_in_station
      when 6
        add_route
      when 7
        add_and_delete_wagon
      when 8
        puts [
          'You are taking:',
          '1 - add station to route',
          '2 - remove station from route'
        ]
        s = gets.to_i
        case s
        when 1
          add_stations_in_route
        when 2
          delete_stations_in_route
        else
          puts 'Wrong value selected, you are taking 1 or 2'
          return
        end
      when 9
        control_booking
      when 10
        move_train
      end
      break if input.zero?
    end
  end

  def creating_stations
    puts "Enter the name of the station (for example: 'Moscow или SPB')."
    name = gets.chomp.capitalize
    station = find_station(name)

    return if station

    @stations << Station.new(name)
    puts "Station #{name} created."
  rescue ValidationError => e
    puts e.message
    retry
  end

  def creating_routes
    puts "Enter the name of the station (for example: 'SPB-Moscow')"
    name_route = gets.chomp.downcase

    puts 'Enter start station'
    starting_stations = gets.chomp.capitalize
    starting = find_station(starting_stations)

    unless starting
      puts "Station #{starting_stations} not found, create station."
      return
    end

    puts 'Enter end station'
    end_stations = gets.chomp.capitalize
    final = find_station(end_stations)

    unless final
      puts "Station #{end_stations} not found, create station."
      return
    end

    @routes << Route.new(name_route, starting, final)
    puts "Route #{name_route} from station #{starting.name} to station #{final.name} created."
  rescue ValidationError => e
    puts e.message
    retry
  end

  def creating_trains
    puts "Enter the train number (for example: '111-QQ')"
    num = gets.chomp.upcase

    puts "Add a train manufacturer (for example: 'Alstom')."
    manufacturer = gets.chomp.capitalize

    puts [
      'You are taking:',
      '1 - Passenger train',
      '2 - Cargo train'
    ]
    n = gets.to_i

    case n
    when 1
      train = PassengerTrain.new(num, manufacturer, Train::PASSENGER_TYPE)
    when 2
      train = CargoTrain.new(num, manufacturer, Train::CARGO_TYPE)
    else
      puts 'Wrong value selected, you are taking 1 or 2'
      return
    end

    @trains << train

    puts "Train number #{num} created, manufacturer: #{manufacturer}"
  rescue ValidationError => e
    puts e.message
    retry
  end

  def creating_wagons
    puts "Add a wagon manufacturer (for example: 'Fesco')."
    manufacturer = gets.chomp.capitalize

    puts 'Enter the capacity of the car (for passenger seats, and for cargo volume).'
    capacity = gets.to_i

    puts [
      'You are taking:',
      '1 - Passenger wagon',
      '2 - Cargo wagon'
    ]
    w = gets.to_i
    
    case w
    when 1
      wagon = PassengerWagon.new(capacity, manufacturer)
    when 2
      wagon = CargoWagon.new(capacity, manufacturer)
    else
      puts 'Wrong value selected, you are taking 1 or 2'
      return
    end

    @wagons << wagon

    puts "Wagon type #{wagon.type} created, manufacturer: #{manufacturer}, capacity #{capacity}"
  rescue ValidationError => e
    puts e.message
    retry
  end

  def list_station
    puts 'List of stations:'
    Station.all.each_with_index { |station, index| puts "#{index + 1} - #{station.name}" }
  end

  def info_train
    puts 'Enter train number'
    num = gets.chomp.upcase
    train = find_train(num)

    return unless train

    puts "Train #{train.num}, found in the system."
    puts "Route assigned to the train '#{train.route&.name_route || 'Train route not assigned!'}'."

    train.each_wagons do |wagon|
      puts "Wagon number: #{wagon.number}, wagon type: #{wagon.type}, Free space (volume): #{wagon.remaining_seat}, Reserved space(volume): #{wagon.occupied_place}"
    end
  end

  def list_train
    puts 'Enter station name'
    name = gets.chomp.capitalize
    station = find_station(name)

    unless station
      puts "Station #{name} not found"
      return
    end

    puts "There are trains at station: #{name}"
    station.each_trains do |train|
      puts "Train number: #{train.num}, train type: #{train.type}, number of wagons #{train.wagon_size}"
    end
  end

  def add_and_delete_wagon
    puts 'Enter train number'
    num = gets.chomp.upcase
    train = find_train(num)

    return unless train

    puts [
      'You are taking:',
      '1 - add a wagon',
      '2 - delete wagon'
    ]
    w = gets.to_i
    case w
    when 1
      wagon = @wagons.find { |wagon| wagon.type == train.type }
      wagon.number = train.wagon_size + 1
      unless wagon
        puts "Suitable wagon not found with type #{train.type}, create a wagon!"
        return
      end

      @wagons.delete(wagon) if train.add_wagon(wagon)
      puts "Wagon No. #{wagon.number} successfully added."
    when 2
      delete_wagon = train.delete_wagon
      @wagons << delete_wagon if delete_wagon
      puts 'The car was successfully uncoupled.'
    end
  end

  def add_route
    puts 'Enter route name'
    name_route = gets.chomp.downcase
    route = find_route(name_route)

    return unless route

    puts 'Enter train number'
    num = gets.chomp.upcase
    train = find_train(num)

    return unless train

    train.add_route(route)
    puts 'Enter train number.'
  end

  def add_stations_in_route
    puts 'To add an intermediate station, enter the name of the route'
    name_route = gets.chomp.downcase
    route = find_route(name_route)

    return unless route

    puts 'Enter way station'
    name = gets.chomp.capitalize
    station = find_station(name)

    unless station
      puts "Station #{name} not found, add station to list!"
      return
    end

    route.add_station(station)
    puts "Way station #{name} added"
  end

  def delete_stations_in_route
    puts 'To delete an intermediate station, enter the name of the route'
    name_route = gets.chomp.downcase
    route = find_route(name_route)

    return unless route

    puts 'Enter way station'
    name = gets.chomp.capitalize
    station = find_station(name)

    unless station
      puts "Station #{name} not found in route!"
      return
    end

    if route.delete_station(station)
      puts 'Station deleted'
    else
      puts 'It is not possible to delete the start and end stations'
    end
  end

  def move_train
    puts 'Enter train number'
    num = gets.chomp.upcase
    train = find_train(num)

    return unless train

    loop do
      puts [
        'You are taking:',
        '1 - Move forward',
        '2 - Move backward',
        '3 - Display current and nearest stations',
        '0 - exit'
      ]
      move = gets.to_i
      case move
      when 1
        train.move_next_station
      when 2
        train.move_previous_station
      when 3
        puts [
          "Previous station - #{train.station_context[:previous_station]}",
          "Current station - #{train.station_context[:current_station]}",
          "Next station - #{train.station_context[:next_station]}"
        ]
      end
      break if move.zero?
    end
  end

  def add_train_in_station
    puts 'Enter train number'
    num = gets.chomp.upcase
    train = find_train(num)

    return unless train

    puts 'Enter station name'
    name = gets.chomp.capitalize
    station = find_station(name)

    unless station
      puts "Station #{name} not found!"
      return
    end

    station.add_train(train)
    puts "#{train} train accepted at station #{name}."
  end

  def print_free_wagons
    puts 'Available free wagons:'
    @wagons.each_with_index { |wagons, index| puts "#{index + 1} - #{wagons.type}" }
  end

  def control_booking
    puts 'Enter train number'
    num = gets.chomp.upcase
    train = find_train(num)

    return unless train
    return unless train.check_occupied_place

    if train.type == Train::PASSENGER_TYPE

      puts 'Book your place? (1-yes or 2-no)'
      input = gets.to_i
      if input == 1
        wagon = train.wagon.find { |w| w.remaining_seat.positive? }
        wagon.take_the_place_of
        puts 'Place reserved!'
      else
        puts 'Place reserved!'
        nil
      end
    else
      puts 'Enter the amount of cargo you want to send'
      volume = gets.to_i
      wagon = train.wagon.find { |w| w.remaining_seat >= volume }

      return puts 'Your volume is too big, try splitting it!' unless wagon

      wagon.take_the_place_of(volume)
      puts 'Place reserved!'
    end
  end

  def find_train(num)
    train = @trains.find { |t| t.num == num }

    unless train
      puts "Train number #{num} not found!"
      return
    end

    train
  end

  def find_station(name)
    @stations.find { |s| s.name == name }
  end

  def find_route(name_route)
    route = @routes.find { |r| r.name_route == name_route }

    unless route
      puts "Named route #{name_route} not found!"
      return
    end

    route
  end

  def station_instances
    puts "Stations created: #{Station.instance}"
  end

  def route_instances
    puts "Routes created: #{Route.instance}"
  end

  def wagon_instances
    puts "Created passenger wagons: #{PassengerWagon.instance}"
    puts "Cargo wagons created: #{CargoWagon.instance}"
  end

  def train_instances
    puts "Created passenger trains: #{PassengerTrain.instance}"
    puts "Created cargo trains: #{CargoTrain.instance}"
  end
end

App.new.run
