require 'instance_counter'
require 'validation'

class Route
  include InstanceCounter
  include Validation

  attr_reader :stations, :name_route

  validate :name_route, :presence
  validate :name_route, :format, /^([a-z]{3,})-([a-z]{3,})$/i

  @instances = 0

  class << self
    def instance
      @instances
    end
  end

  def initialize(name_route, starting_stations, end_stations)
    @name_route = name_route
    validate!
    @stations = [starting_stations, end_stations]

    register_instance
  end

  def add_station(new_stations)
    @stations.insert(-2, new_stations)
  end

  def print_stations
    @stations.each_with_index { |station, index| puts "#{index + 1} - #{station.name}" }
  end

  def delete_station(station)
    if [@stations.first, @stations.last].include? station
      false
    else
      @stations.delete(station)
      true
    end
  end
end
