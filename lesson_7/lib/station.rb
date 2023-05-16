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
      @instances
    end
  end


  def initialize(name) #Имеет название, которое указывается при ее создании-
    @name = name
    validate!
    @@stations << self
    @trains = []
    register_instance
  end

  def valid?
    validate!
    true
  rescue
    false
  end
    
  def add_train(train) #Может принимать поезда (по одному за раз)
    @trains << train
  end
    
  def print_trains #Может возвращать список всех поездов на станции, находящиеся в текущий момент
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
  end

  def each_trains(&block)
    @trains.each(&block)
  end
  

  private

  STATION_FORMAT = /^[a-z]{3,}$/i

  def validate!
    raise ValidationError.new(name, "Неверный формат названия станции. Минимальное количество символов '3'") if name !~ STATION_FORMAT
  end
end