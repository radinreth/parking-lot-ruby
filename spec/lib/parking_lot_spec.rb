require 'parking_lot'
require 'car'
require 'byebug'

RSpec.describe ParkingLot do
  let(:parking_lot) { ParkingLot.new }

  before do
    parking_lot.create_parking_lot(6, 1.00, 0)
  end

  after(:each) do
    Schedule.destroy_all
  end

  describe "#create_parking_lot" do
    specify { expect(parking_lot.slot_count).to eq(6) }
    specify { expect(parking_lot.rate_hourly).to eq(1.00) }
    specify { expect(parking_lot.grace_period).to eq(0) }
  end

  describe "#park" do
    let(:car1) { Car.new('ABC-1234', 'White') }
    let(:car2) { Car.new('ABC-5678', 'Black') }

    it "records parking info" do
      expect {
        parking_lot.park(car1, '08:00')
        parking_lot.park(car2, '16:00')
      }.to change { Schedule.busy_slots.count }.by 2

      expect(Schedule.all[0].car).to eq car1
      expect(Schedule.all[1].car).to eq car2
    end
  end

  describe "#leave" do
    let(:car1) { Car.new('ABC-1234', 'White') }
    let(:car2) { Car.new('ABC-5678', 'Black') }

    before do
      parking_lot.park(car1, '08:00')
      parking_lot.park(car2, '16:00')
    end

    it "free the car's slot after leave" do
      expect {
        parking_lot.leave(car1, '09:00')
      }.to change { Schedule.free_slots.count }.by 1
      expect(Schedule.busy_slots.count).to eq 1
      expect(Schedule.busy_slots[0].car).to eq car2
    end
  end

  describe "status" do
    let(:new_parking_lot) { ParkingLot.new }

    let(:car1) { Car.new("abc-111", "white") }
    let(:car2) { Car.new("abc-222", "black") }
    let(:car3) { Car.new("abc-333", "white") }
    let(:car4) { Car.new("abc-444", "black") }
    let(:car5) { Car.new("abc-555", "blue") }

    before do
      Schedule.destroy_all
      new_parking_lot.create_parking_lot(6, 10.00, 15)

      new_parking_lot.park(car1, '08:00')
      new_parking_lot.park(car2, '10:00')
      new_parking_lot.park(car3, '05:30')
      new_parking_lot.park(car4, '14:00')
      new_parking_lot.park(car5, '17:00')

      new_parking_lot.leave(car1, '08:15')
      new_parking_lot.leave(car3, '06:00')
      new_parking_lot.leave(car4, '14:10')
      new_parking_lot.leave(car5, '20:00')
    end

    it "returns number of cars that entered" do
      expect(new_parking_lot.entered_cars.count).to eq 5
    end

    it "returns number of cars that leaved" do
      expect(new_parking_lot.leaved_cars.count).to eq 4
    end

    it "returns number of cars IN grace period" do
      expect(new_parking_lot.cars_in_grace_period.count).to eq 2
      expect(new_parking_lot.cars_in_grace_period[0].car).to eq car1
      expect(new_parking_lot.cars_in_grace_period[1].car).to eq car4
    end

    it "returns number of cars NOT IN grace period" do
      expect(new_parking_lot.cars_not_in_grace_period.count).to eq 2
      expect(new_parking_lot.cars_not_in_grace_period[0].car).to eq car3
      expect(new_parking_lot.cars_not_in_grace_period[1].car).to eq car5
    end

    it "#total_earn" do
      item_count = new_parking_lot.cars_not_in_grace_period.count
      rate = new_parking_lot.rate_hourly

      expect(new_parking_lot.total_earn).to eq(item_count * rate)
    end

    it "#status" do
      expect(new_parking_lot.status).to match(/#{new_parking_lot.total_earn}/)
    end

    it "#log" do
      expect(new_parking_lot.log).to match(/#{car1.plate_number}/m)
    end
  end
end
