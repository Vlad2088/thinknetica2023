require 'manufacturer.rb'
require 'instance_counter.rb'

class Wagon

  include Manufacturer
  include InstanceCounter

  @instances = 0

  attr_reader :type

  def initialize(manufacturer_name)
    @manufacturer_name = manufacturer_name
    
    validate_manufacturer!
    register_instance
  end

  def valid?
    validate_manufacturer!
  rescue
    false
  end
end