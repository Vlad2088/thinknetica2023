require 'instance_counter.rb'

class Route

  include InstanceCounter

  attr_reader :stations, :name_route

  @instances = 0

  class << self
    def instance
      @instances
    end
  end

  def initialize(name_route, starting_stations, end_stations) #Имеет начальную и конечную станцию, а также список промежуточных станций. Начальная и конечная станции указываютсся при создании маршрута, а промежуточные могут добавляться между ними.
    @name_route = name_route
    validate!
    @stations = [starting_stations, end_stations]

    register_instance
  end

  def valid?
    validate!
  rescue
    false
  end
    
  def add_station(new_stations) #Может добавлять промежуточную станцию в список
    @stations.insert(-2, new_stations)
  end
    
  def print_stations #Может выводить список всех станций по-порядку от начальной до конечной
    @stations.each_with_index{|station, index| puts "#{index + 1} - #{station.name}"}
  end
    
  def delete_station(station) #Может удалять промежуточную станцию из списка
    if [@stations.first, @stations.last].include? station
      false
    else @stations.delete(station)
      true
    end
  end

  private

  ROUTE_FORMAT = /^([a-z]{3,})-([a-z]{3,})$/i

  def validate!
    raise ValidationError.new(name_route, "Неверный формат наименования маршрута. Допустимый формат: ХХХ-ХХХ") if name_route !~ ROUTE_FORMAT
    true
  end
end
