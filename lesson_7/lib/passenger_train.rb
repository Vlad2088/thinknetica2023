class PassengerTrain < Train
  attr_reader :type

  @instances = 0

  class << self
    def instance
      @instances
    end
  end

  def initialize(num, manufacturer_name, type)
    @type = PASSENGER_TYPE
    super(num, manufacturer_name)  
  end
end
