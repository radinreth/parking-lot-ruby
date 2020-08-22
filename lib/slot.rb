class Slot
  attr_accessor :number, :car

  def initialize(car = nil)
    @car = car
  end

  def free?
    car.nil?
  end

  def free!
    self.car = nil
    self
  end

  def occupy(car)
    self.car = car
  end
end
