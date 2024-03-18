module SessionsHelper
  def signed_in?
    current_user.present?
  end

  def current_user
    if user_id = session[:user_id]
      @current_user ||= User.find_by id: user_id
    elsif user_id = cookies.signed[:user_id]
      user = User.find_by id: user_id
      if user.try :authenticated?, :remember, cookies[:remember_token]
        sign_in user
        @current_user = user
      end
    end
  end

  def admin?
    current_user&.admin?
  end
end
