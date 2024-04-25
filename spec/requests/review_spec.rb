require "rails_helper"

RSpec.describe ReviewsController, type: :request do
  let!(:user) {FactoryBot.create(:user)}
  let!(:booking) {FactoryBot.create(:booking)}
  let!(:review) {double(:review, id: 111)}
  let!(:review_params) {{rating: 4, comment: "Comment", booking_id: booking.id}}

  before do
    sign_in user
  end

  describe "POST #create" do
    before do
      allow(Booking).to receive(:find_by).and_return(booking)
    end

    context "booking can be reviewed" do
      before do
        allow(booking).to receive(:can_be_reviewed?).and_return(true)
      end

      it "with valid params" do
        post reviews_path, params: {review: review_params}
        parsed_body = JSON.parse(response.body)
        expect(parsed_body["message"]).to match(/successfully/)
      end

      it "with invalid params" do
        allow(Review).to receive(:new).and_return(review)
        allow(review).to receive(:save).and_return(false)
        post reviews_path, params: {review: review_params}
        parsed_body = JSON.parse(response.body)
        expect(parsed_body["message"]).to match(/failed/i)
      end
    end

    context "booking can not be reviewed" do
      it "render json failed message" do
        allow(booking).to receive(:can_be_reviewed?).and_return(false)
        post reviews_path, params: {review: review_params}
        parsed_body = JSON.parse(response.body)
        expect(parsed_body["message"]).to match(/Can't rate/)
      end
    end
  end

  describe "PUT #update" do
    context "review found" do
      before do
        allow(Review).to receive(:find_by).and_return(review)
      end

      it "success" do
        allow(review).to receive(:update).and_return(true)
        put reviews_path, params: {review: review_params}
        parsed_body = JSON.parse(response.body)
        expect(parsed_body["message"]).to match(/success/)
      end

      it "failed" do
        allow(review).to receive(:update).and_return(false)
        put reviews_path, params: {review: review_params}
        parsed_body = JSON.parse(response.body)
        expect(parsed_body["message"]).to match(/failed/)
      end
    end

    context "review not found" do
      it "render message failed" do
        allow(Review).to receive(:find_by).and_return(nil)
        put reviews_path, params: {id: review.id, review: review_params}
        parsed_body = JSON.parse(response.body)
        expect(parsed_body["message"]).to match(/not found/)
      end
    end
  end
end
