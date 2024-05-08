class AuthenticationTokenService
  HMAC_SECRET = ENV["hmac_secret"]
  ALGORITHM_TYPE = ENV["algorithm_type"]

  class << self
    def call user_id
      payload = {user_id:}
      JWT.encode payload, HMAC_SECRET, ALGORITHM_TYPE
    end

    def decode token
      decode_token = JWT.decode token, HMAC_SECRET, true,
                                {algorithm: ALGORITHM_TYPE}
      decode_token[0]["user_id"]
    rescue StandardError
      raise StandardError, "Invalid token"
    end
  end
end
