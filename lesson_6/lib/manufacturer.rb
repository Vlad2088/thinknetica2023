module Manufacturer
  attr_accessor :manufacturer_name

  private

  MANUFACTURER_FORMAT = /^[a-z]{3,}$/i

  def validate_manufacturer!
    raise ValidationError.new(manufacturer_name, "Неверный формат имени производителя. Минимальное количество символов '3'") if manufacturer_name !~ MANUFACTURER_FORMAT
    true
  end

end