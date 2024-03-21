class ApplicationController < ActionController::Base
  include Pagy::Backend
  include SessionsHelper

  before_action :set_locale

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

  def redirect_back_or default
    forwarding_url = session[:forwarding_url]
    session.delete :forwarding_url
    redirect_to forwarding_url || default
  end

  def sign_in user
    session[:user_id] = user.id
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

  def signed_in_user
    return if signed_in?

    store_location
    flash[:danger] = t "flash.must_sign_in"
    redirect_to signin_url
  end

  def require_admin
    return if admin?

    flash[:warning] = t "flash.require_admin"
    redirect_to root_path
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
end
