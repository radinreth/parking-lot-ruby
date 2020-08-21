class Slot
  attr_accessor :number, :car

  def initialize(car = nil)
    @car = car
  end

  def available?
    car.nil?
  end

  def available!
    self.car = nil
  end

  def occupy(car)
    self.car = car
  end
end
