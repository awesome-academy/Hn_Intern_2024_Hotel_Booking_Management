require "rails_helper"

RSpec.describe RoomType, type: :model do

  describe "instance method" do
    let(:room_type) {FactoryBot.create(:room_type)}
    it "#active" do
      room_type.active
      expect(room_type.active?).to eq(true)
    end

    it "#inactive" do
      room_type.inactive
      expect(room_type.inactive?).to eq(true)
    end

    it "#can_be_inactive? true" do
      expect(room_type.can_be_inactive?).to be true
    end
  end

  describe "callback" do
    let(:room_type) {FactoryBot.create(:room_type)}
    it "change active rooms after change room type's status" do
      room_type.inactive
      expect(room_type.rooms.first.status).to eq("inactive")
    end
  end
end
