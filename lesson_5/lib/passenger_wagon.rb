class PassengerWagon < Wagon

  @instances = 0

  class << self
    def instance
      puts "Создано пассажирских вагонов: #{@instances}"
    end
  end


  def initialize
    @type = Train::PASSENGER_TYPE
    super
    puts "Вагон создан"
  end
end
