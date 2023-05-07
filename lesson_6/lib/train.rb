require 'manufacturer.rb'
require 'instance_counter.rb'

class Train 
  
  include Manufacturer
  include InstanceCounter
  

  CARGO_TYPE = :cargo
  PASSENGER_TYPE = :passenger
    
  attr_reader :num, :route

  @@trains = []
  @instances = 0

  class << self
    def search_train(num)
    @@trains.find {|t| t.num == num}
    end
  end
    
  def initialize(num, manufacturer_name) #Имеет номер (произвольная строка) и тип (грузовой, пассажирский) и количество вагонов, эти данные указываются при создании экземпляра класса
    @num = num  
    @manufacturer_name = manufacturer_name
    validate!
    @wagons = []
    @route
    @@trains << self
    @current_speed = 0
    @current_station

    register_instance
  end
  
  def valid?
    validate!
  rescue
    false
  end
    
  def accelerate #Может набирать скорость
    @current_speed = @current_speed + rand(1..5)
  end
    
  def stop #Может тормозить (сбрасывать скорость до нуля)
    @current_speed = [@current_speed - rand(1..5), 0].max
  end
    
  def speed #Может возвращать текущую скорость
    @current_speed
  end
    
  def add_wagon(wagon)  #Может прицеплять вагоны (по одному вагону за операцию, метод просто увеличивает количество вагонов). Прицепка вагонов может осуществляться только если поезд не движется.
    if @current_speed == 0 && type == wagon.type
      @wagons << wagon 
      true
    else
      puts "Вагон невозможно дабавить, поезд в движении." 
      false
    end
  end 
    
  def delete_wagon   #Может отцеплять вагоны (по одному вагону за операцию, метод просто уменьшает количество вагонов). Отцепка вагонов может осуществляться только если поезд не движется. 
    if @current_speed == 0
      @wagons.pop 
    else
      puts "Вагон невозможно отцепить, поезд в движении или отсутствуют вагоны."
      nil
    end
  end 

  def wagon_size
    @wagons.size
  end

  def add_route(route) #Может принимать маршрут следования (объект класса Route). 
    @route = route 
    @current_station = route.stations[0] #При назначении маршрута поезду, поезд автоматически помещается на первую станцию в маршруте.
  end

  def move_next_station #Может перемещаться между станциями, указанными в маршруте. Вперед
    return puts "Вы прибыли на конечную станцию!" if final_station?(current_station_index)

    @current_station = route.stations[current_station_index + 1]
    puts "Поезд прибыл на станцию #{@current_station.name}"
  end
    
  def move_previous_station #Может перемещаться между станциями, указанными в маршруте. Назад
    return puts "Поезд не может двигаться назад! Вы находитесь на начальной станции!" if strarting_station?(current_station_index)
       
    @current_station = route.stations[current_station_index - 1]
    puts "Поезд прибыл на станцию #{@current_station.name}"
  end
    
  def current_station_index #Может перемещаться между станциями, указанными в маршруте.
    route.stations.each_with_index{|title, i| break i if @current_station == title}
  end
    
  def station_context #Возвращать предыдущую станцию, текущую, следующую, на основе маршрута
    {
      previous_station: route.stations[current_station_index - 1].name,
      current_station: @current_station.name,
      next_station: route.stations[current_station_index + 1].name
    }
  end
    

  private

  NUMBER_FORMAT = /^(\d{3}|[a-z]{3})-*(\d{2}|[a-z]{2})$/i

  def validate!
    raise ValidationError.new(num, "Неверный формат номера поезда. Допустимый формат: ХХХ-ХХ или ХХХХХ") if num !~ NUMBER_FORMAT
    validate_manufacturer!
    true
  end

  def final_station?(index)
    index == route.stations.size - 1 
  end

  def strarting_station?(index)
    index == 0
  end
end