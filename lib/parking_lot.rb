require 'slot'
require 'car'
require 'byebug'

class ParkingLot
  attr_accessor :schedule
  attr_reader :slot_count, :rate_hourly, :grace_period

  def create_parking_lot(slot_count, rate_hourly, grace_period)
    @slot_count = slot_count
    @rate_hourly = rate_hourly
    @grace_period = grace_period

    @schedule = Schedule.new(slot_count)
    self
  end

  def park(car, entry_time)
    @schedule.add(car, entry_time)
  end

  def leave(car, exit_time)
    @schedule.remove(car, exit_time)
  end

  def entered_cars
    Schedule.entered_cars
  end

  def leaved_cars
    Schedule.leaved_cars
  end

  def cars_in_grace_period
    leaved_cars.select { |slot| slot.in_grace?(@grace_period) }
  end

  def cars_not_in_grace_period
    leaved_cars - cars_in_grace_period
  end

  def total_earn
    @rate_hourly * cars_not_in_grace_period.count
  end

  def status
    <<-STR
    Total earn: #{total_earn}
    Number of enter: #{entered_cars.count}
    Number of leave: #{leaved_cars.count}

    *SETTING:
    Number of slots: #{@slot_count}
    Hourly rate: #{@rate_hourly}
    Grace period: #{@grace_period}
    STR
  end

  def log
    <<-STR
    Plate No. | Color | Entry | Departure
    #{
      entered_cars.map do |sl|
        "#{sl.car.plate_number} | #{sl.car.colour} | #{sl.entry_time} | #{sl.exit_time}"
      end.join('\r\n')
    }
    STR
  end
end
