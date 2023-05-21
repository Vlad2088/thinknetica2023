module Manufacturer
  attr_accessor :manufacturer_name

  private

  MANUFACTURER_FORMAT = /^[a-z]{3,}$/i

  def validate_manufacturer!
    return unless manufacturer_name !~ MANUFACTURER_FORMAT

    raise ValidationError.new(manufacturer_name,
                              "Invalid manufacturer name format. Minimum number of characters '3'")
  end
end
