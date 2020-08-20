require 'parking_lot'

RSpec.describe ParkingLot do
  let(:parking_lot) { ParkingLot.new }

  before do
    parking_lot.slots = 6
  end

  it 'creates slots' do
    expect(parking_lot.slots).to eq(6)
  end
end
