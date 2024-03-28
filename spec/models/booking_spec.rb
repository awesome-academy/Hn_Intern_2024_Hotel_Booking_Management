require "rails_helper"

RSpec.describe Booking, type: :model do

  describe "callback" do
    it "clear reason if not rejected" do
      booking = FactoryBot.create(:booking)
      booking.update status: :confirmed
      expect(booking.reason).to be nil
    end
  end

  describe "instance method" do
    let(:booking) {FactoryBot.create(:booking)}
    before(:each) {booking}

    it "#can_be_deleted?" do
      booking.update status: :pending
      expect(booking.can_be_deleted?).to be true
    end

    it "#total_price" do
      total_price = booking.num_of_night * booking.amount * booking.price
      expect(booking.total_price).to eq(total_price)
    end

    it "#num_of_night" do
      res = ((booking.check_out - booking.check_in) / 86400).to_i
      expect(booking.num_of_night).to eq(res)
    end

    it "#send_mail_booking case confirmed" do
      booking.update status: :confirmed
      expect {booking.send_mail_booking}.to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    it "#send_mail_booking case rejected" do
      booking.update status: :rejected
      expect {booking.send_mail_booking}.to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    it "#can_be_reviewed?" do
      expect(booking.can_be_reviewed?).to be false
    end

    it "#can_be_reviewed? true" do
      booking.update status: :completed, completed_at: DateTime.now, reason: ""
      expect(booking.can_be_reviewed?).to be true
    end
  end

  describe "scope" do
    it ".newest" do
      bking_1 = FactoryBot.create(:booking)
      bking_2 = FactoryBot.create(:booking)
      bking_3 = FactoryBot.create(:booking)
      arr = [bking_1, bking_2, bking_3].sort_by {|bk| [bk[:book_day].to_i * -1, bk[:check_in]]}
      expect(Booking.newest).to eq(arr)
    end
  end
end
