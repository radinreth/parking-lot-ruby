require_relative 'base_args'

class SlotNumberForRegistrationNumberArgs < BaseArgs
  def args
    @params.first
  end
end
