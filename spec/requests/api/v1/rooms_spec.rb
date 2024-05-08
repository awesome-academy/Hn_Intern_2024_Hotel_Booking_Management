require 'rails_helper'

RSpec.describe "Api::V1::Rooms", type: :request do
  let!(:rooms) {FactoryBot.create_list(:room, 5)}

  describe "GET #index" do
    it "response's status is ok" do
      get "/api/v1/rooms"
      expect(response).to have_http_status(:ok)
    end

    it "response's body have rooms" do
      get "/api/v1/rooms"

      json_response = JSON.parse response.body
      expect(json_response["rooms"]).to_not be_empty
    end
  end
end
