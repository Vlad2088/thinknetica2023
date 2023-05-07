class ValidationError < StandardError
  attr_reader :error

  def initialize(error, message)
    @error = error
    super(message)
  end
end

