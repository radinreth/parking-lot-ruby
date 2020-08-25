require 'car'
require 'schedule'

RSpec.describe Schedule do
  describe "#add" do
    let(:car) { Car.new('abc-111', 'white') }

    before(:each) do
      @record = subject.add(1, car, '08:00', '09:00')
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
  end
end
