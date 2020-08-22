require 'slot'

RSpec.describe Slot do
  let(:slot) { Slot.new }

  before do
    slot.number = 1
  end

  specify { expect(slot.number).to eq(1) }

  describe '#free?' do
    let(:car) { Car.new(plate_number: 'abc-1111', colour: 'White') }

    specify { expect(slot).to be_free }

    it 'is not free' do
      slot.car = car

      expect(slot).not_to be_free
    end
  end
end
