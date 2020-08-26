require 'slot'
require 'car'
require 'byebug'

RSpec.describe Slot do
  let(:slot) { Slot.new }
  let(:car) { Car.new('abc-1111', 'White') }

  describe '#free?' do
    specify { expect(slot).to be_free }

    context "Free" do
      it 'has no car' do
        slot.car = nil

        expect(slot).to be_free
      end

      it 'has exit_time' do
        slot.exit_time = '01:00'

        expect(slot).to be_free
      end
    end

    context "Not Free" do
      it 'has car and no exit_time' do
        slot.car = car
        slot.exit_time = nil

        expect(slot).not_to be_free
      end
    end
  end

  describe "free!" do
    before do
      slot.car = car
      slot.exit_time = nil
    end

    specify { expect(slot).not_to be_free }
    it "free the slot" do
      slot.free!

      expect(slot).to be_free
    end
  end
end
