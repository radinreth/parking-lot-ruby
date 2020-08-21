require 'slot'

class OverLimitException < StandardError; end

class ParkingLot
  attr_accessor :slots

  def initialize(slots_count:)
    @slots = build_slots(slots_count)
  end

  def park(car)
    raise OverLimitException if available_slots.count.zero?

    slot = available_slots.first
    slot.occupy(car)
    slot
  end

  def available_slots
    @slots.select(&:available?)
  end

  def used_slots
    @slots - available_slots
  end

  def plate_numbers_for_cars_with_colour(colour)
    scoped = used_slots.select { |slot| slot.car.colour == colour }
    scoped.map { |slot| slot.car.plate_number }
  end

  def slot_numbers_for_cars_with_colour(colour)
    scoped = used_slots.select { |slot| slot.car.colour == colour }
    scoped.map(&:number)
  end

  def slot_number_for_registration_number(plate_number)
    scoped = used_slots.select { |slot| slot.car.plate_number == plate_number }
    return 'Not found' if scoped.empty?

    scoped.first.number
  end

  private

  def build_slots(count)
    slots = []

    count.times.each do |num|
      slot = Slot.new
      slot.number = num + 1
      slots << slot
    end

    slots
  end
end
