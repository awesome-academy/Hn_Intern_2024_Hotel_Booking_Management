class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params.dig(:session, :email)&.downcase
    if user.try :authenticate, params.dig(:session, :password)
      authenticate_success user
    else
      flash[:danger] = t ".flash_create_danger"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    log_out
    redirect_to root_path, status: :see_other
  end

  private

  def authenticate_success user
    sign_in user
    params.dig(:session, :remember_me) == "1" ? remember(user) : forget(user)
    flash[:success] = t ".flash_create_success"
    redirect_back_or root_path
  end

  def log_out
    forget current_user
    session.delete :user_id
    @current_user = nil
  end

  def remember user
    user.remember_me
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def forget user
    user.forget
    cookies.delete :user_id
    cookies.delete :remember_token
  end
end
