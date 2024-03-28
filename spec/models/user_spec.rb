require "rails_helper"

RSpec.describe User, type: :model do

  describe "callbacks" do
    it "downcase email before saving" do
      user = FactoryBot.create(:user)
      user.email.upcase!
      user.save
      email = user.email
      expect(user.email).to eq(email.downcase)
    end
  end

  describe "validations" do
    let(:user) {FactoryBot.create(:user)}
    context "when email is not present" do
      it "is not valid" do
        user.email = nil
        expect(user).to_not be_valid
      end
    end

    context "when full name is not present" do
      it "is not valid" do
        user.full_name = nil
        expect(user).to_not be_valid
      end
    end

    context "when email format is invalid" do
      it "is not valid" do
        user.email = "asdadsd"
        expect(user).to_not be_valid
      end
    end

    context "when password is not present" do
      it "is not valid" do
        user.password = nil
        expect(user).to_not be_valid
      end
    end
  end

  describe "scopes" do
    let(:user) {FactoryBot.create(:user)}
    context ".activated" do
      it "includes users with status unlocked" do
        user.update locked_at: nil
        expect(User.activated("unlocked")).to include(user)
      end

      it "includes users with status locked" do
        user.update locked_at: Date.today
        expect(User.activated("locked")).to include(user)
      end
    end
  end

  describe "instance method" do
    it "#get_bookings" do
      user_bookings = FactoryBot.create(:user_with_bookings)
      expect(user_bookings.get_bookings).to eq(user_bookings.bookings.newest)
    end
  end
end
