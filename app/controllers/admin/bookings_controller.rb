class Admin::BookingsController < Admin::BaseController
  before_action :load_booking, only: %i(show update)

  def index
    @pagy, @bookings = pagy Booking.newest,
                            items: Settings.digits.digit_5
  end

  def show; end

  def update
    if @booking.update booking_params
      flash[:success] = t ".flash_update_success"
      @booking.send_mail_confirm
      redirect_to admin_bookings_path
    else
      @booking.reload
      flash[:danger] = t ".flash_update_danger"
      render :show, status: :unprocessable_entity
    end
  end

  private
  def booking_params
    params.require(:booking).permit :status, :reason
  end
end
