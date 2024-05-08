require 'rails_helper'

RSpec.describe "Api::V1::Bookings", type: :request do

  let!(:user) {FactoryBot.create(:user_with_bookings)}
  let!(:token) {
    post "/api/v1/authenticate", params: {email: user.email, password: user.password}
    JSON.parse(response.body)["token"]
  }
  let!(:booking) {user.bookings[0]}
  let!(:room_type) {FactoryBot.create(:room_type)}

  describe "GET #index" do
    it "returns http status ok" do
      get "/api/v1/bookings", headers: {"Authorization" => "Bearer #{token}"}
      expect(response).to have_http_status(:ok)
    end

    context "authenticate failed" do
      it "invalid token" do
        get "/api/v1/bookings", headers: {"Authorization" => "Bearer #{token + "asdf"}"}
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "GET #show" do
    it "returns http status ok" do
      get "/api/v1/bookings/#{booking.id}", headers: {"Authorization" => "Bearer #{token}"}
      expect(response).to have_http_status(:ok)
    end

    it "returns error when not found" do
      get "/api/v1/bookings/1000", headers: {"Authorization" => "Bearer #{token}"}
      expect(JSON.parse(response.body)["error"]).to_not be_blank
    end
  end

  describe "POST #create" do
    let!(:booking_params) {FactoryBot.attributes_for(:booking)}
    context "with valid params" do
      it "returns http status created" do
        post "/api/v1/bookings", params: {booking: booking_params.merge(room_type_id: room_type.id)}, headers: {"Authorization" => "Bearer #{token}"}
        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid params" do
      it "returns http status unprocessable_entity" do
        post "/api/v1/bookings", params: {booking: booking_params}, headers: {"Authorization" => "Bearer #{token}"}
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
