class Route
    attr_reader :stations
    
    def initialize(starting_stations, end_stations) #Имеет начальную и конечную станцию, а также список промежуточных станций. Начальная и конечная станции указываютсся при создании маршрута, а промежуточные могут добавляться между ними.
        @stations = [starting_stations, end_stations]

        puts "Маршрут от станции #{starting_stations.name} до станции #{end_stations.name} создан."
    end
    
    def add_station(new_stations) #Может добавлять промежуточную станцию в список
        @stations.insert(-2, new_stations)

        puts "Промежуточная станция #{new_stations.name} добавлена"
    end
    
    def print_stations #Может выводить список всех станций по-порядку от начальной до конечной
        puts "Маршрут поезда:"

        @stations.each_with_index{|station, index| puts "#{index + 1} - #{station.name}"}
    end
    
    def delete_station(station) #Может удалять промежуточную станцию из списка
        if [@stations.first, @stations.last].include? station
            puts "Начальную и конечную станцию удалить невозжожно"
        elsif @stations.delete(station)
            puts "Станция удалена"
        else
            puts "Станции в маршруте не существует"
        end
    end
end
