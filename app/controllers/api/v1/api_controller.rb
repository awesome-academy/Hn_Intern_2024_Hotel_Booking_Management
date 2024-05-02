module Api::V1
  class ApiController < ActionController::API
    include Pagy::Backend

    def authenticate_user
      token, _options = token_and_options(request)
      user_id = AuthenticationTokenService.decode(token)
      @user ||= User.find(user_id)
    rescue StandardError => e
      render json: {"error" => e.message}, status: :unauthorized
    end
  end
end
