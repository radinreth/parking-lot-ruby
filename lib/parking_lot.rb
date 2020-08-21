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
