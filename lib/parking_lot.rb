require_relative 'slot'
require_relative 'car'
require 'byebug'

class OverLimitException < StandardError; end

class ParkingLot
  attr_accessor :slots

  def create_parking_lot(slots_count)
    @slots = build_slots(slots_count)
    self
  end

  def create_parking_lot_say(parking_lot)
    "Created a parking lot with #{parking_lot.slots.count} slots"
  end

  def park(car_attrs)
    raise StandardError.new('Sorry, parking lot is full') if free_slots.count.zero?

    car = Car.new(car_attrs)
    slot = free_slots.first
    slot.occupy(car)
    slot
  end

  def park_say(slot)
    "Allocated slot number: #{slot.number}"
  end

  def free_slots
    @slots.select(&:free?)
  end

  def used_slots
    @slots - free_slots
  end

  def leave(slot_number)
    slot = used_slots.select { |s| s.number == slot_number }.first
    slot&.free!
  end

  def leave_say(slot)
    "Slot number #{slot.number} is free"
  end

  def status
    result = []
    used_slots.each do |slot|
      info  = [slot.number]
      info += [slot.car.plate_number]
      info += [slot.car.colour]

      result << info.join(' | ')
    end

    result.join('<CR>')
  end

  def status_say(result)
    header = 'Slot No. | Plate Number | Colour <CR>'
    header + result
  end

  def plate_numbers_for_cars_with_colour(colour)
    scoped = used_slots.select { |slot| slot.car.colour == colour }
    scoped.map { |slot| slot.car.plate_number }
  end

  def plate_numbers_for_cars_with_colour_say(result)
    result.join(', ')
  end

  def slot_numbers_for_cars_with_colour(colour)
    scoped = used_slots.select { |slot| slot.car.colour == colour }
    scoped.map(&:number)
  end

  def slot_numbers_for_cars_with_colour_say(result)
    result.join(', ')
  end

  def slot_number_for_registration_number(plate_number)
    scoped = used_slots.select { |slot| slot.car.plate_number == plate_number }
    raise StandardError.new('Not found') if scoped.empty?

    scoped.first.number
  end

  def slot_number_for_registration_number_say(result)
    result
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
