require 'ostruct'

class Schedule
  @@lists = []

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

    def first
      @@lists.first
    end
  end

  def add(slot, car, entry_time, exit_time)
    row = ::OpenStruct.new(slot: slot, car: car, entry_time: entry_time, exit_time: exit_time)
    @@lists << row
    row
  end
end
