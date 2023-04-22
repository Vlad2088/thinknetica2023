class CargoWagon < Wagon

  def initialize
    @type = Train::CARGO_TYPE
    super
    puts "Вагон создан"
  end
end