class Slot
  attr_accessor :number, :car, :entry_time, :exit_time

  def free?
    car.nil? || !exit_time.nil?
  end

  def free!
    self.car = nil
    self.entry_time = nil
    self.exit_time = nil

    self
  end
end
