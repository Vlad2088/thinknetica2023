require 'validation'
require 'manufacturer'

class CargoWagon < Wagon
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
    @type = Train::CARGO_TYPE
    super(capacity, manufacturer_name)
    validate!
  end

  def take_the_place_of(volume)
    @occupied_place += volume
  end
end