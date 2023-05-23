require 'manufacturer'
require 'instance_counter'
require 'validation'

class Wagon
  include Manufacturer
  include InstanceCounter
  include Validation


  @instances = 0

  attr_reader :type, :capacity, :occupied_place
  attr_accessor :number

  validate :manufacturer_name, :format, Manufacturer::MANUFACTURER_FORMAT

  def initialize(capacity = 0, manufacturer_name)
    @capacity = capacity
    @manufacturer_name = manufacturer_name
    @number = nil
    @occupied_place = 0

    validate!
    register_instance
  end

  def number_wagon
    @number
  end

  def remaining_seat
    capacity - occupied_place
  end
end