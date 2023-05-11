require 'manufacturer.rb'
require 'instance_counter.rb'

class Wagon

  include Manufacturer
  include InstanceCounter

  @instances = 0


  attr_reader :type, :capacity, :occupied_place
  attr_accessor :number

  def initialize(capacity = 0, manufacturer_name)
    @manufacturer_name = manufacturer_name
    @number = nil
    @capacity = capacity
    @occupied_place = 0
    
    validate_manufacturer!
    register_instance
  end

  def number_wagon
    @number
  end

  def remaining_seat
    @capacity - @occupied_place
  end

  def valid?
    validate_manufacturer!
    true
  rescue
    false
  end
end