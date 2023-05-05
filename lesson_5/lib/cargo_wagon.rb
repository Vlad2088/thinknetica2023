class CargoWagon < Wagon

  @instances = 0

  class << self
    def instance
      puts "Создано грузовых вагонов: #{@instances}"
    end
  end

  def initialize
    @type = Train::CARGO_TYPE
    super
    puts "Вагон создан"
  end
end