require 'parking_lot'

RSpec.describe ParkingLot do
  let(:parking_lot) { ParkingLot.new }

  before do
    parking_lot.slots = 6
  end

  it 'creates slots' do
    expect(parking_lot.slots).to eq(6)
  end

  describe 'A car enters my parking lot' do
    it 'reserves a space for the car' do
      car = Car.new(plate_number: 'ABC-1111', colour: 'Blue')

      expect {
        parking_lot.park(car)
      }.to change { parking_lot.slots }.by(-1)
    end
  end
end
