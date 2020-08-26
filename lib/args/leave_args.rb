require_relative 'base_args'
require_relative '../car'

class LeaveArgs < BaseArgs
  def args
    plate_number, exit_time = @params
    [Car.new(plate_number, ''), exit_time]
  end
end
