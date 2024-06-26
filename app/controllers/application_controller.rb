class ApplicationController < ActionController::Base
  include Pagy::Backend
  include BookingsHelper

  before_action :authenticate_user!, :find_image, :check_image_owner,
                only: :remove_profile_image

  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for resource
    if resource.admin?
      admin_dashboard_path
    else
      root_path
    end
  end

  def load_room
    @room = Room.find_by id: params[:id]
    return if @room

    flash[:warning] = t "flash.room_not_found"
    redirect_to root_path
  end

  def load_booking
    @booking = Booking.find_by id: params[:id]
    return if @booking

    flash[:warning] = t "flash.booking_not_found"
    redirect_to root_path
  end

  def require_admin
    return if current_user.try(:admin?)

    redirect_to root_path,
                alert: t("flash.require_admin")
  end

  def remove_profile_image
    @image.purge_later
    redirect_to request.referer || root_path, notice: t("flash.delete_success")
  end

  private

  def default_url_options
    {locale: I18n.locale}
  end

  def set_locale
    I18n.locale = extract_locale || I18n.default_locale
  end

  def extract_locale
    parsed_locale = params[:locale]
    return unless I18n.available_locales.map(&:to_s).include?(parsed_locale)

    parsed_locale.to_sym
  end

  def find_image
    @image = ActiveStorage::Attachment.find_by id: params[:id]

    return if @image.present?

    redirect_to request.referer || root_path,
                alert: t("flash.image_not_found")
  end

  def check_image_owner
    return if @image.record_id == current_user.id || current_user.admin?

    redirect_to request.referer || root_path,
                alert: t("flash.can_not_perform")
  end

  protected
  def configure_permitted_parameters
    added_attrs = %i(
      full_name email password password_confirmation
      remember_me profile_image
    )
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end
end
