require 'parking_lot'
require 'car'
require 'byebug'

RSpec.describe ParkingLot do
  let(:parking_lot) { ParkingLot.new(slots_count: 6) }

  it '#available_slots' do
    expect(parking_lot.available_slots.count).to eq(6)
  end

  describe '#park' do
    let(:red_toyota) { Car.new(plate_number: 'ABC-1111', colour: 'Red') }
    let(:blue_bmw) { Car.new(plate_number: 'ABC-1112', colour: 'Blue') }

    it 'parks the first car to the first slot' do
      slot = parking_lot.park(red_toyota)

      expect(slot.number).to eq(1)
      expect(slot.car).to eq(red_toyota)
      expect(slot).not_to be_available
    end

    it 'parks the 2nd cars to the next slot' do
      slot1 = parking_lot.park(red_toyota)
      slot2 = parking_lot.park(blue_bmw)

      expect(slot1.number).to eq(1)
      expect(slot2.number).to eq(2)
    end

    describe 'parks the next car to the NEAREST to the entry' do
      before do
        slot = parking_lot.slots.first
        slot.occupy(red_toyota)
      end

      it 'parks to the 2nd slot' do
        slot = parking_lot.park(blue_bmw)

        expect(slot.number).to eq(2)
      end
    end

    describe 'parking lot is full' do
      let(:small_parking_lot) { ParkingLot.new(slots_count: 2) }
      let(:green_lambo) { Car.new(plate_number: 'ABC-2222', colour: 'Green') }

      it 'cannot park over limit' do
        expect do
          small_parking_lot.park(red_toyota)
          small_parking_lot.park(blue_bmw)
          small_parking_lot.park(green_lambo)
        end.to raise_error(OverLimitException)
      end
    end

    describe 'mark a slot available' do
      before do
        @slot = parking_lot.slots.first
        @slot.occupy(red_toyota)
      end

      it 'sets the slot available after customer exit' do
        @slot.available!
        new_slot = parking_lot.park(blue_bmw)

        expect(new_slot.number).to eq(1)
      end
    end
  end

  xdescribe 'Example: interactive' do
    describe '.find' do
      it 'shows all plate numbers of all cars with a particular colour'
      it 'shows slot number of a given plate number'
      it 'shows all slot numbers of a particular colour'
      it 'shows NOT FOUND for non-parked plate number'
    end
  end

  describe 'Example: File' do
  end
end
