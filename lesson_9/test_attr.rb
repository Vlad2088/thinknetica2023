$LOAD_PATH << './lib'

require 'station'
require 'route'
require 'train'
require 'wagon'
require 'cargo_train'
require 'passenger_train'
require 'cargo_wagon'
require 'passenger_wagon'
require 'manufacturer'
require 'instance_counter'
require 'validation_error'
require 'accessors'
require 'validation'

tr = Train.new('111-11', 'Testing')
  #=> #<Train: @current_speed=0, @manufacturer_name='Testing', @num='111-11', @wagons=[]>

tr.accelerate
  #=> 2

tr.accelerate
  #=> 6

tr.accelerate
  #=> 9

tr
  #=> #<Train: @current_speed=9, @current_speed_history=[0, 2, 6], @manufacturer_name='Testing', @num='111-11', @wagons=[]>
  
