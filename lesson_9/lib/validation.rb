module Validation
  def self.included(base)
    base.extend ClassMethods
    base.class_eval do
      @validations = []
      class << self
        attr_reader :validations
      end
    end
  end

  module ClassMethods
    def validate(name, type, param=nil)
      @validations << { name: name, type: type, param: param }
    end
  end

  def validate!
    self.class.validations.each do |validation|
      value = instance_variable_get("@#{validation[:name]}")
      send(validation[:type], validation[:name], value, validation[:param])
    end
  end

  def valid?
    validate!
    true
  rescue ValidationError => e
    puts e
    false
  end

  private

  def presence(name, value, param=nil)
    raise ValidationError.new("Value of #{name} can't be nil or empty!") if value.nil? || value.empty?
  end

  def format(name, value, format)
    raise ValidationError.new("Value of #{name} doesn't match format") unless value.to_s =~ format
  end

  def type(name, value, type)
    raise ValidationError.new("Error! Invalid class type #{name}.") unless value.is_a?(type)
  end

  def self.inherited(subclass)
    subclass.class_eval do
      @validations = superclass.validations.dup 
      class << self
        attr_reader :validations
      end
    end
  end
end