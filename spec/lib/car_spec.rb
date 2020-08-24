require 'car'

RSpec.describe Car do
  let(:car) { Car.new(plate_number: 'ABC-1234', colour: 'White', entry_time: '08:00') }

  specify { expect(car.plate_number).to eq('ABC-1234') }
  specify { expect(car.colour).to eq('White') }
  specify { expect(car.entry_time).to eq('08:00') }
end
