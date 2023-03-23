$LOAD_PATH << './lib'

require 'station.rb'
require 'route.rb'
require 'train.rb'

class App

  def run
    station1 = Station.new("Red")
    station2 = Station.new("White")
    station3 = Station.new("Black")
    station4 = Station.new("Blue")

    route1 = Route.new(station1, station2)
    route2 = Route.new(station3, station4)    

    train1 = Train.new("123", Train::CARGO_TYPE, 8)
    train2 = Train.new("456", Train::CARGO_TYPE, 6)
    train3 = Train.new("789", Train::PASSENGER_TYPE, 5)

    station1.add_train(train1)
    station1.add_train(train2)
    station1.add_train(train3)

    station1.print_trains
    station1.cargo_trains_count
    station1.passenger_trains_count
    station1.delete_train(train2)
    station1.print_trains

    route1.add_statoin(station3)
    route1.add_statoin(station4)
    route1.print_stations
    route1.delete_station(station3)
    route1.print_stations

    train1.accelerate
    train1.speed
    train1.stop

    train2.add_wagons
    train2.delete_wagons
    train2.wagons_quantity

    train3.add_route(route1)
    train3.move_next_station
    train3.station_context
    train3.move_previous_station
    train3.station_context
  end
end

App.new.run
