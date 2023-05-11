class CargoWagon < Wagon

  @instances = 0
  

  class << self
    def instance
      @instances
    end
  end

  def initialize(capacity = 0, manufacturer_name)
    @type = Train::CARGO_TYPE
    super(capacity, manufacturer_name)
  end

  def take_the_place_of(volume)
    @occupied_place = @occupied_place + volume
  end

 
end