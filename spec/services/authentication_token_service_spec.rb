require "rails_helper"

RSpec.describe AuthenticationTokenService do
  let!(:token) {described_class.call(1)}

  describe ".call" do
    it "return an authentication token" do
      decoded_token = JWT.decode(
        token,
        described_class::HMAC_SECRET,
        true,
        { algorithm: described_class::ALGORITHM_TYPE }
      )

      expect(decoded_token).to eq(
        [
          {"user_id"=>1}, {"alg"=>"HS256"}
        ]
      )
    end
  end
end
