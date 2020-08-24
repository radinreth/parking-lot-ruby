class Car
  attr_accessor :plate_number, :colour, :entry_time

  def initialize(plate_number:, colour:, entry_time:)
    @plate_number = plate_number
    @colour = colour
    @entry_time = entry_time
  end
end
