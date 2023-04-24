class PassengerTrain < Train
  attr_reader :type

  def initialize(num, type)
    @type = PASSENGER_TYPE
    super(num)  
  end
end
