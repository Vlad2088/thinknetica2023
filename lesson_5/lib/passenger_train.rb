class PassengerTrain < Train
  attr_reader :type

  @instances = 0

  class << self
    def instance
      puts "Создано пассажирскийх поездов: #{@instances}"
    end
  end

  def initialize(num, type)
    @type = PASSENGER_TYPE
    super(num)  
  end
end
