require 'parking_lot'
require 'car'
require 'byebug'

RSpec.describe ParkingLot do
  let(:parking_lot) { ParkingLot.new }

  before do
    @parking_lot = parking_lot.create_parking_lot(6, 1.00, 0)
  end

  specify { expect(@parking_lot.rate_hourly).to eq(1.00) }
  specify { expect(@parking_lot.grace_period).to eq(0) }

  describe "#leave" do
    let(:car_attrs) { { plate_number: 'AAA-111', colour: 'Blue' } }

    it "free the slot after the car leaves" do
      @parking_lot.park(car_attrs, entry_time: '08:00')

      @parking_lot.leave(car_attrs[:plate_number], exit_time: '09:00')
    end
  end

  it '#free_slots' do
    expect(@parking_lot.free_slots.count).to eq(6)
  end

  describe '#park' do
    let(:red_toyota) { { plate_number: 'ABC-1111', colour: 'Red' } }
    let(:blue_bmw) { { plate_number: 'ABC-1112', colour: 'Blue' } }

    it 'parks the first car to the first slot' do
      slot = @parking_lot.park(red_toyota, entry_time: '08:00')

      expect(slot.number).to eq(1)
      expect(slot.car.plate_number).to eq(red_toyota[:plate_number])
      expect(slot.car.colour).to eq(red_toyota[:colour])
      expect(slot).not_to be_free
    end

    it 'parks the 2nd cars to the next slot' do
      slot1 = @parking_lot.park(red_toyota, entry_time: '08:00')
      slot2 = @parking_lot.park(blue_bmw, entry_time: '08:00')

      expect(slot1.number).to eq(1)
      expect(slot2.number).to eq(2)
    end

    describe 'parks the next car to the NEAREST to the entry' do
      before do
        slot = @parking_lot.slots.first
        slot.occupy(red_toyota)
      end

      it 'parks to the 2nd slot' do
        slot = @parking_lot.park(blue_bmw, entry_time: '08:00')

        expect(slot.number).to eq(2)
      end
    end

    describe 'parking lot is full' do
      let(:small_parking_lot) { ParkingLot.new }
      let(:green_lambo) { Car.new(plate_number: 'ABC-2222', colour: 'Green') }

      before do
        @small_parking_lot = small_parking_lot.create_parking_lot(2, 1.00, 0)
      end

      it 'cannot park over limit' do
        expect do
          @small_parking_lot.park(red_toyota, entry_time: '08:00')
          @small_parking_lot.park(blue_bmw, entry_time: '08:00')
          @small_parking_lot.park(green_lambo, entry_time: '08:00')
        end.to raise_error(StandardError, 'Sorry, parking lot is full')
      end
    end

    describe 'mark a slot free' do
      before do
        @slot = @parking_lot.slots.first
        @slot.occupy(red_toyota)
      end

      it 'sets the slot free after customer exit' do
        @slot.free!
        new_slot = @parking_lot.park(blue_bmw, entry_time: '08:00')

        expect(new_slot.number).to eq(1)
      end
    end

    describe 'find' do
      let(:car1) { { plate_number: 'ABC-1234', colour: 'White' } }
      let(:car2) { { plate_number: 'ABC-9999', colour: 'White' } }
      let(:car3) { { plate_number: 'ABC-0001', colour: 'Black' } }
      let(:car4) { { plate_number: 'ABC-7777', colour: 'Red' } }
      let(:car5) { { plate_number: 'ABC-2701', colour: 'Blue' } }
      let(:car6) { { plate_number: 'ABC-3141', colour: 'Black' } }
      let(:new_car) { { plate_number: 'ABC-333', colour: 'White' } }

      before do
        @parking_lot.park(car1, entry_time: '08:00')
        @parking_lot.park(car2, entry_time: '08:00')
        @parking_lot.park(car3, entry_time: '08:00')
        slot4 = @parking_lot.park(car4, entry_time: '08:00')
        @parking_lot.park(car5, entry_time: '08:00')
        @parking_lot.park(car6, entry_time: '08:00')

        slot4.free!
      end

      it '#status' do
        puts @parking_lot.status
        expect(@parking_lot.status).to match(/#{car1[:plate_number]}/)
      end

      context "government regulation" do
        before do
          @parking_lot.park(new_car, entry_time: '08:00')
        end

        it '.plate_numbers_for_cars_with_colour' do
          plate_numbers = @parking_lot.plate_numbers_for_cars_with_colour('White')

          expect(plate_numbers).to eq %w[ABC-1234 ABC-9999 ABC-333]
        end

        it '.slot_numbers_for_cars_with_colour' do
          plate_numbers = @parking_lot.slot_numbers_for_cars_with_colour('White')

          expect(plate_numbers).to eq [1, 2, 4]
        end

        describe '.slot_number_for_registration_number' do
          it 'returns slot_number' do
            plate_numbers = @parking_lot.slot_number_for_registration_number('ABC-3141')

            expect(plate_numbers).to eq 6
          end

          it 'returns not found' do
            expect {
              @parking_lot.slot_number_for_registration_number('DEF-1111')
            }.to raise_error(StandardError, 'Not found')
          end
        end
      end
    end
  end

  describe 'Example: File' do
  end
end
