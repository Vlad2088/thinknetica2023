  class CargoTrain < Train
    attr_reader :type

    def initialize(num, type)
      @type = CARGO_TYPE
      super(num)  
    end
  end

#module Trains
#end