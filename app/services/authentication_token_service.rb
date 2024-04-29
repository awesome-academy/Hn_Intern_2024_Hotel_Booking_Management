class AuthenticationTokenService
  HMAC_SECRET = ENV["hmac_secret"]
  ALGORITHM_TYPE = ENV["algorithm_type"]

  def self.call user_id
    payload = {user_id:}
    JWT.encode payload, HMAC_SECRET, ALGORITHM_TYPE
  end
end
