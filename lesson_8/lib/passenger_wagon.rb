class PassengerWagon < Wagon
  @instances = 0

  class << self
    def instance
      @instances
    end
  end

  def initialize(capacity = 0, manufacturer_name)
    @type = Train::PASSENGER_TYPE
    super(capacity, manufacturer_name)
  end

  def take_the_place_of
    @occupied_place += 1
  end
end
