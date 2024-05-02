require "rails_helper"

RSpec.describe "Authentication", type: :request do
  describe "POST /authenticate" do
    let!(:user) {FactoryBot.create(:user, email: "tester@gmail.com", password: "Test123@" )}

    context "authenticates the user with valid params" do
      it "response's status is created" do
        post "/api/v1/authenticate", params: {email: user.email, password: user.password}
        expect(response).to have_http_status(:created)
      end

      it "response's body contains token" do
        post "/api/v1/authenticate", params: {email: user.email, password: user.password}
        token = AuthenticationTokenService.call(user.id)
        expect(JSON.parse response.body).to eq({"token" => token})
      end
    end

    context "authenticate the user with invalid params" do
      it "return error when email is missing" do
        post "/api/v1/authenticate", params: {password: user.password}

        expect(JSON.parse response.body).to eq({
          "error" => "param is missing or the value is empty: email"
        })
      end

      it "return error when password is missing" do
        post "/api/v1/authenticate", params: {email: user.email}

        expect(JSON.parse response.body).to eq({
          "error" => "param is missing or the value is empty: password"
        })
      end

      it "return error when password is incorrect" do
        post "/api/v1/authenticate", params: {email: user.email,  password: "incorrect"}

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
