class Admin::BookingsController < Admin::BaseController
  before_action :load_booking, only: %i(show update)

  def index
    @q = Booking.ransack(params[:q])
    @q.sorts = ["status asc", "book_day desc"] if @q.sorts.empty?
    @pagy, @bookings = pagy @q.result,
                            items: Settings.digits.digit_8
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
