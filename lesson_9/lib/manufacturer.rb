module Manufacturer
  attr_accessor :manufacturer_name

  MANUFACTURER_FORMAT = /^[a-z]{3,}$/i
end
