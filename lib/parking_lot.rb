class ParkingLot
  attr_accessor :slots

  def park(car)
    @slots -= 1
  end
end
