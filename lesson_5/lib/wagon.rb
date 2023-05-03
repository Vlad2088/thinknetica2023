require 'manufacturer.rb'
require 'instance_counter.rb'

class Wagon

  include Manufacturer
  include InstanceCounter

  @instances = 0

  attr_reader :type

  def initialize
    register_instance
  end
end