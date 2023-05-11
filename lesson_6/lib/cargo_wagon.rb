class CargoWagon < Wagon

  @instances = 0

  class << self
    def instance
      @instances
    end
  end

  def initialize(manufacturer_name)
    @type = Train::CARGO_TYPE
    super(manufacturer_name)
  end
end