require_relative 'base_args'
require_relative '../car'

class ParkArgs < BaseArgs
  def args
    plate_number, colour, entry_time = @params
    [Car.new(plate_number, colour), entry_time]
  end
end
