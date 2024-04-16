class Admin::UsersController < Admin::BaseController
  before_action :load_user, only: %i(lock_user unlock_user show)
  before_action :check_user_role, only: %i(lock_user unlock_user)

  def index
    @q = User.user.ransack params[:q]
    @q.sorts = ["id asc"] if @q.sorts.empty?
    @pagy, @users = pagy @q.result, items: Settings.digits.digit_5
  end

  def lock_user
    @user.lock_access!
    redirect_to request.referer || admin_users_path,
                notice: t("flash.inactivated")
  end

  def unlock_user
    @user.unlock_access!
    redirect_to request.referer || admin_users_path,
                notice: t("flash.activated")
  end

  def show; end

  private
  def load_user
    @user = User.find_by id: params[:id]
    return if @user.try :user?

    redirect_to admin_dashboard_path, alert: t("flash.user_not_found")
  end

  def check_user_role
    return unless @user.admin?

    redirect_to admin_users_path,
                alert: t("flash.can_not_perform")
  end
end
