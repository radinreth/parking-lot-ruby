require 'time'

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
  
  def in_grace?(grace_period)
    duration_in_min <= grace_period
  end
  
  private

  def duration_in_min
    ( Time.parse(exit_time) - Time.parse(entry_time) ) / 60
  end
end
