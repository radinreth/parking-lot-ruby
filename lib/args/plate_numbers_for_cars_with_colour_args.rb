require_relative 'base_args'

class PlateNumbersForCarsWithColourArgs < BaseArgs
  def args
    @params.first
  end
end
