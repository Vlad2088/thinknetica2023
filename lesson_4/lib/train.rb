class Train 
    
  CARGO_TYPE = :cargo
  PASSENGER_TYPE = :passenger
    
  attr_reader :num, :route
    
  def initialize(num) #Имеет номер (произвольная строка) и тип (грузовой, пассажирский) и количество вагонов, эти данные указываются при создании экземпляра класса
    @num = num  
    @wagons = []
    @route
    @current_speed = 0
    @current_station
    puts "Поезд под номером #{num} создан."
  end
    
  def accelerate #Может набирать скорость
    @current_speed = @current_speed + rand(1..5)

    puts "Поезд набрал скорость: #{@current_speed} км/ч"
  end
    
  def stop #Может тормозить (сбрасывать скорость до нуля)
    @current_speed = [@current_speed - rand(1..5), 0].max

    puts "Поезд сбросил скорость: #{@current_speed} км/ч"
  end
    
  def speed #Может возвращать текущую скорость
    puts "Текущая скорость поезда: #{@current_speed} км/ч" 
  end
    
  def add_wagon(wagon)  #Может прицеплять вагоны (по одному вагону за операцию, метод просто увеличивает количество вагонов). Прицепка вагонов может осуществляться только если поезд не движется.
    if @current_speed == 0 && type == wagon.type
      @wagons << wagon 
      puts "Вагон успешно добавлен."
      true
    else
      puts "Вагон невозможно дабавить, поезд в движении." 
      false
    end
  end 
    
  def delete_wagon   #Может отцеплять вагоны (по одному вагону за операцию, метод просто уменьшает количество вагонов). Отцепка вагонов может осуществляться только если поезд не движется. 
    if @current_speed == 0
      @wagons.pop 
      puts "Вагон успешно отцеплен."
    else
      puts "Вагон невозможно отцепить, поезд в движении или отсутствуют вагоны."
      nil
    end
  end 

  def add_route(route) #Может принимать маршрут следования (объект класса Route). 
    @route = route 
    @current_station = route.stations[0] #При назначении маршрута поезду, поезд автоматически помещается на первую станцию в маршруте.
    puts "Маршрут принят. Поезд находится на станции #{@current_station.name}"
  end
    
  def move_next_station #Может перемещаться между станциями, указанными в маршруте. Вперед
    return puts "Вы прибыли на конечную станцию!" if final_station?(current_station_index)

    @current_station = route.stations[current_station_index + 1]
    puts "Поезд прибыл на станцию #{@current_station.name}"
  end
    
  def move_previous_station #Может перемещаться между станциями, указанными в маршруте. Назад
    return puts "Поезд не может двигаться назад! Вы находитесь на начальной станции!" if strarting_station?(current_station_index)
       
    @current_station = route.stations[current_station_index - 1]
    puts "Поезд прибыл на станцию #{@current_station.name}"
  end
    
  def current_station_index #Может перемещаться между станциями, указанными в маршруте.
    route.stations.each_with_index{|title, i| break i if @current_station == title}
  end
    
  def station_context #Возвращать предыдущую станцию, текущую, следующую, на основе маршрута
    {
      previous_station: route.stations[current_station_index - 1].name,
      current_station: @current_station.name,
      next_station: route.stations[current_station_index + 1].name
    }
  end
    

  private

  def final_station?(index)
    index == route.stations.size - 1 
  end

  def strarting_station?(index)
    index == 0
  end
end