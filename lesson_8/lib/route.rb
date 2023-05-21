require 'instance_counter'

class Route
  include InstanceCounter

  attr_reader :stations, :name_route

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

  def valid?
    validate!
    true
  rescue StandardError
    false
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

  private

  ROUTE_FORMAT = /^([a-z]{3,})-([a-z]{3,})$/i

  def validate!
    return unless name_route !~ ROUTE_FORMAT

    raise ValidationError.new(name_route,
                              'Invalid route name format. Valid Format: XXX-XXX')
  end
end
