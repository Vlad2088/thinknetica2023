require 'validation'
require 'manufacturer'

class CargoTrain < Train
  include Validation
  include Manufacturer

  attr_reader :type

  validate :num, :format, Train::NUMBER_FORMAT
  validate :manufacturer_name, :format, Manufacturer::MANUFACTURER_FORMAT

  @instances = 0

  class << self
    def instance
      @instances
    end
  end

  def initialize(num, manufacturer_name, _type)
    @type = CARGO_TYPE
    super(num, manufacturer_name)
    validate!
  end
end