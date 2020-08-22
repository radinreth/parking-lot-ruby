class BaseArgs
  def initialize(params)
    @params = params
  end

  def args
    @params.first.to_i
  end
end
