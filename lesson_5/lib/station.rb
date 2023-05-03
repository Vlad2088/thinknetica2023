require 'instance_counter.rb'

class Station 
  
  include InstanceCounter

  attr_reader :name

  @@stations = []
  @instances = 0
  
  class << self
    def all
      @@stations
    end

    def instance
      puts "Создано станций: #{@instances}"
    end
  end
    
  def initialize(name) #Имеет название, которое указывается при ее создании-
    @name = name
    @@stations << self
    @trains = []
    puts "Станция #{name} создана."
    register_instance
  end

  def list_station #Посмотр списка станций
    puts "Список станций:"
    @name.each_with_index{|name, index| puts "#{index + 1} - #{name.name}"}
  end
    
  def add_train(train) #Может принимать поезда (по одному за раз)
    @trains << train

    puts "На станции #{@name} принят #{train.num} поезд."
  end
    
  def print_trains #Может возвращать список всех поездов на станции, находящиеся в текущий момент
    puts "На станции находятся поезда:"

    @trains.each{ |train| puts "#{train.num}" }
  end
    
  def trains_by_type(train_type) #Может возвращать список поездов на станции по типу (см. ниже): кол-во грузовых, пассажирских
    @trains.select { |train| train.type == train_type }
  end
    
  def cargo_trains_count
    trains_by_type(Train::CARGO_TYPE).size
  end
    
  def passenger_trains_count
    trains_by_type(Train::PASSENGER_TYPE).size
  end
    
  def delete_train(train) #Может отправлять поезда (по одному за раз, при этом, поезд удаляется из списка поездов, находящихся на станции).
    @trains.delete(train)

    puts "Со станции #{@name} убыл #{train.num} поезд."
  end
end