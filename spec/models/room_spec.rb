require "rails_helper"

RSpec.describe Room, type: :model do

  describe "instance method" do
    let(:room) {FactoryBot.create(:room)}
    before(:each) {room}
    it "#inactive" do
      room.active
      room.inactive
      expect(room.status).to eq("inactive")
    end

    it "#active" do
      room.inactive
      room.active
      expect(room.status).to eq("active")
    end

    it "#can_be_inactive? return true" do
      expect(room.can_be_inactive?).to be true
    end
  end

  describe "validates" do
    context "when name is not present" do
      it "is not valid" do
        room = FactoryBot.create(:room)
        room.name = ""
        expect(room).to_not be_valid
      end
    end

    context "when name is duplicated" do
      it "is not valid" do
        room = FactoryBot.create(:room)
        room_2 = FactoryBot.create(:room)
        room_2.name = room.name
        expect(room_2).to_not be_valid
      end
    end
  end
end
