require 'slot'

class Schedule
  attr_reader :slot_count

  @@lists = []

  def initialize(slot_count)
    @slot_count = slot_count
    prepare
  end

  class << self
    def all
      @@lists
    end

    def destroy_all
      @@lists = []
    end

    def count
      all.count
    end

    def free_slots
      all.select(&:free?)
    end

    def nearest_free_slot
      free_slots.map(&:number).min
    end

    def busy_slots
      all - free_slots
    end

    def entered_cars
      all.select { |slot| !slot.car.nil? }
    end

    def leaved_cars
      all.select { |slot| !slot.exit_time.nil? }
    end

    %i[number car].each do |attr|
      define_method "find_by_#{attr}".to_sym do |param|
        all.detect { |r| r.send(attr) == param }
      end
    end
  end

  def add(car, entry_time)
    row = Schedule.find_by_number(Schedule.nearest_free_slot)
    row.car = car
    row.entry_time = entry_time

    row
  end

  def remove(car, exit_time)
    row = Schedule.find_by_car(car)
    row.exit_time = exit_time if row

    row
  end

  private

  def prepare
    @slot_count.times.each do |num|
      slot = ::Slot.new
      slot.number = num + 1

      @@lists << slot
    end
  end
end
