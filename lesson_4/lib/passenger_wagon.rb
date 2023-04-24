class PassengerWagon < Wagon

  def initialize
    @type = Train::PASSENGER_TYPE
    super
    puts "Вагон создан"
  end
end
