require_relative 'base_args'

class ParkArgs < BaseArgs
  def args
    plate_number, colour = @params
    { plate_number: plate_number, colour: colour }
  end
end
