require 'validation'
require 'manufacturer'

class PassengerWagon < Wagon
  include Validation
  include Manufacturer
  
  validate :manufacturer_name, :format, Manufacturer::MANUFACTURER_FORMAT

  @instances = 0

  class << self
    def instance
      @instances
    end
  end

  def initialize(capacity = 0, manufacturer_name)
    @type = Train::PASSENGER_TYPE
    super(capacity, manufacturer_name)
    validate!
  end

  def take_the_place_of
    @occupied_place += 1
  end
end
