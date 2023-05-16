require 'instance_counter'

class Station
  include InstanceCounter

  attr_reader :name

  @@stations = []
  @instances = 0

  class << self
    def all
      @@stations
    end

    def instance
      @instances
    end
  end

  def initialize(name)
    @name = name
    validate!
    @@stations << self
    @trains = []
    register_instance
  end

  def valid?
    validate!
    true
  rescue StandardError
    false
  end

  def add_train(train)
    @trains << train
  end

  def trains_by_type(train_type)
    @trains.select { |train| train.type == train_type }
  end

  def cargo_trains_count
    trains_by_type(Train::CARGO_TYPE).size
  end

  def passenger_trains_count
    trains_by_type(Train::PASSENGER_TYPE).size
  end

  def delete_train(train)
    @trains.delete(train)
  end

  def each_trains(&block)
    @trains.each(&block)
  end

  private

  STATION_FORMAT = /^[a-z]{3,}$/i

  def validate!
    return unless name !~ STATION_FORMAT

    raise ValidationError.new(name,
                              "Invalid station name format. Minimum number of characters '3'")
  end
end
