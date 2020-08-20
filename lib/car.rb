class Car
  attr_accessor :plate_number, :colour

  def initialize(plate_number:, colour:)
    @plate_number = plate_number
    @colour = colour
  end
end
