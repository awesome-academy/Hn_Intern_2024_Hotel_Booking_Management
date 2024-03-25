class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]
    if user && !user.activated && user.authenticated?(:activation, params[:id])
      user.activate
      sign_in user
      flash[:success] = t ".flash_edit_success"
    else
      flash[:danger] = t ".flash_edit_danger"
    end
    redirect_to root_path
  end
end
