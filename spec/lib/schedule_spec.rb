require 'car'
require 'schedule'
require 'byebug'

RSpec.describe Schedule do

  before do
    @schedule = Schedule.new(5)
  end

  after do
    Schedule.destroy_all
  end

  specify { expect(Schedule.count).to eq 5 }
  specify { expect(Schedule.busy_slots.length).to eq 0 }
  specify { expect(Schedule.free_slots.length).to eq 5 }
  specify { expect(Schedule.nearest_free_slot).to eq 1 }

  it '.find' do
    expect(Schedule.find_by_number(1).number).to eq 1
    expect(Schedule.find_by_number(2).number).to eq 2
  end

  describe '.add' do
    let(:car) { Car.new('abc-111', 'white') }

    context "one car" do
      it "record a car with entry time" do
        expect {
          @schedule.add(car, "08:00")
        }.to change { Schedule.busy_slots.count }.by 1
      end
    end
  end

  describe '.remove' do
    let(:car) { Car.new('abc-111', 'white') }

    context "one car" do
      before do
        @schedule.add(car, "08:00")
      end

      it "updates exit_time" do
        expect {
          @schedule.remove(car, "09:00")
        }.to change { Schedule.free_slots.count }.by 1
      end
    end

    context "many cars" do
      let(:car2) { Car.new('abc-112', 'black') }
      let(:car3) { Car.new('abc-113', 'blue') }
      let(:car4) { Car.new('abc-114', 'green') }

      before do
        @schedule.add(car, "06:00")
        @slot2 = @schedule.add(car2, "05:00")
        @schedule.add(car3, "10:00")
      end

      it "marks the slot available after leave" do
        @schedule.remove(@slot2.car, "06:00")

        expect(@slot2).to be_free
      end

      it "parks of free slot" do
        @schedule.remove(@slot2.car, "06:30")
        row = @schedule.add(car4, "07:00")

        expect(row.number).to eq 2
      end
    end
  end


  xdescribe "#enter" do
    let(:car) { Car.new('abc-111', 'white') }

    before(:each) do
      @record = subject.enter(car, '08:00')
    end

    after do
      Schedule.destroy_all
    end

    it "increments size of list" do
      expect(Schedule.count).to eq 1
      expect(Schedule.first).to eq @record
    end

    it '.all' do
      expect(Schedule.all).to eq [@record]
    end

    it '.free_slots' do
      expect(Schedule.free_slots).to eq []
    end

    it '.busy_slots' do
      expect(Schedule.busy_slots).to eq [@record]
    end

    describe "#enter" do
      it 'returns the first slot number' do
        expect(Schedule.all[0].slot).to eq 1
      end

      it 'returns the second slot number' do
        subject.enter(car, '10:00')

        expect(Schedule.second.slot).to eq 2
      end
    end

    describe "#exit_time" do
      it "return the first slot if it's free" do
        subject.exit(car, '09:00')

        expect(Schedule.count).to eq 1
        expect(Schedule.first.slot).to eq 1
        expect(Schedule.first.exit_time).to eq '09:00'
      end

      it 'raises when exit time is greater than entry_time'
      it 'cannot exit for non-existence car'
    end
  end
end