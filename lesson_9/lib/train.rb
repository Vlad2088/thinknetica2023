require 'manufacturer'
require 'instance_counter'
require 'accessors'
require 'validation'

class Train
  include Manufacturer
  include InstanceCounter
  include Validation
  extend Accessor

  CARGO_TYPE = :cargo
  PASSENGER_TYPE = :passenger
  NUMBER_FORMAT = /^(\d{3}|[a-z]{3})-*(\d{2}|[a-z]{2})$/i


  attr_reader :num, :route
  attr_accessor_with_history :current_speed

  validate :num, :presence
  validate :num, :format, NUMBER_FORMAT
  validate :manufacturer_name, :format, Manufacturer::MANUFACTURER_FORMAT


  @instances = 0

  def initialize(num, manufacturer_name)
    @num = num
    @manufacturer_name = manufacturer_name
    validate!
    @wagons = []
    @current_speed = 0

    register_instance
  end

  def accelerate
    self.current_speed = @current_speed + rand(1..5)
  end

  def stop
    self.current_speed = [current_speed - rand(1..5), 0].max
  end

  def speed
    self.current_speed
  end

  def add_wagon(wagon)
    if self.current_speed.zero? && type == wagon.type
      @wagons << wagon

      true
    else
      puts 'The car cannot be added, the train is in motion.'
      false
    end
  end

  def delete_wagon
    if self.current_speed.zero?
      @wagons.pop
    else
      puts 'The car cannot be uncoupled, the train is in motion or there are no cars.'
      nil
    end
  end

  def wagon_size
    @wagons.size
  end

  def wagon
    @wagons
  end

  def each_wagons(&block)
    @wagons.each(&block)
  end

  def add_route(route)
    @route = route
    @current_station = route.stations[0]
  end

  def move_next_station
    return puts 'You have arrived at the terminal station!' if final_station?(current_station_index)

    @current_station = route.stations[current_station_index + 1]
    puts "The train arrived at the station #{@current_station.name}"
  end

  def move_previous_station
    if strarting_station?(current_station_index)
      return puts 'The train cannot move backward! You are at the starting station!'
    end

    @current_station = route.stations[current_station_index - 1]
    puts "The train arrived at the station #{@current_station.name}"
  end

  def current_station_index
    route.stations.each_with_index { |title, i| break i if @current_station == title }
  end

  def station_context
    {
      previous_station: route.stations[current_station_index - 1].name,
      current_station: @current_station.name,
      next_station: route.stations[current_station_index + 1].name
    }
  end

  def check_occupied_place
    occupied_place = @wagons.sum(&:occupied_place)
    capacity = @wagons.sum(&:capacity)

    return true if capacity - occupied_place.positive?

    puts "There is no empty seat on this train, Used #{occupied_place}, total #{capacity}"
    false
  end

  private

  def final_station?(index)
    index == route.stations.size - 1
  end

  def strarting_station?(index)
    index.zero?
  end
end
