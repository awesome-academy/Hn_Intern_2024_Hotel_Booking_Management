module Api::V1
  class AuthenticationController < ApiController
    class AuthenticationError < StandardError; end

    rescue_from ActionController::ParameterMissing, with: :parameter_missing
    rescue_from AuthenticationError, with: :handle_unauthenticated

    def create
      raise AuthenticationError unless user.try(:valid_password?,
                                                params.require(:password))

      token = AuthenticationTokenService.call(user.id)

      render json: {token:}, status: :created
    end

    private
    def user
      @user ||= User.find_by email: params.require(:email)
    end

    def parameter_missing err
      render json: {error: err.message}, status: :unprocessable_entity
    end

    def handle_unauthenticated
      head :unauthorized
    end
  end
end
