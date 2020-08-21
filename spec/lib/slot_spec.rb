require 'slot'

RSpec.describe Slot do
  let(:slot) { Slot.new }

  before do
    slot.number = 1
  end

  specify { expect(slot.number).to eq(1) }

  describe '#available?' do
    let(:car) { Car.new(plate_number: 'abc-1111', colour: 'White') }

    specify { expect(slot).to be_available }

    it 'is not available' do
      slot.car = car

      expect(slot).not_to be_available
    end
  end
end
