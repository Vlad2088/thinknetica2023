class CargoTrain < Train
  attr_reader :type

  @instances = 0

  class << self
    def instance
      @instances
    end
  end

  def initialize(num, manufacturer_name, _type)
    @type = CARGO_TYPE
    super(num, manufacturer_name)
  end
end
