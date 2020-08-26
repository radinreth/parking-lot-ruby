require 'car'

RSpec.describe Car do
  let(:car) { Car.new('ABC-1234', 'White') }

  specify { expect(car.plate_number).to eq('ABC-1234') }
  specify { expect(car.colour).to eq('White') }
end
