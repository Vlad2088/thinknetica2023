class CargoTrain < Train
  attr_reader :type

  @instances = 0

  class << self
    def instance
      puts "Создано грузовых поездов: #{@instances}"
    end
  end


  def initialize(num, type)
    @type = CARGO_TYPE
    super(num)  
  end
end

