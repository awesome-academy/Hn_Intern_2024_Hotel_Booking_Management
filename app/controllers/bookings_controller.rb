class BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_booking, only: %i(show destroy)
  before_action :create_booking, only: :create

  def index
    @q = current_user.bookings.ransack(params[:q])
    @q.sorts = ["status asc", "id desc"] if @q.sorts.empty?
    @pagy, @bookings = pagy @q.result,
                            items: Settings.digits.digit_3
  end

  def show
    render turbo_stream:
      turbo_stream.replace("show-detail-booking",
                           partial: "detail",
                           locals: {booking: @booking})
  end

  def new
    @booking = current_user.bookings.new booking_params_to_new
    @room_type = RoomType.find_by id: params[:room_type_id]
  end

  def create
    if save_booking
      flash[:success] = t ".flash_create_success"
      AutoCheckBookingJob.perform_at(
        Settings.auto_check_booking_delay.seconds.from_now, @booking.id
      )
      redirect_to root_path
    else
      @room_type = RoomType.find_by id: @booking.room_type_id
      flash.now[:danger] = t ".flash_create_danger"
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update; end

  def destroy
    if @booking.can_be_deleted? && @booking.destroy
      flash[:success] = t ".flash_destroy_success"
    else
      flash[:danger] = t ".flash_destroy_danger"
    end
    redirect_to request.referer
  end

  private
  def booking_params_to_create
    params.require(:booking).permit :note, :full_name, :email, :telephone,
                                    :check_in, :check_out, :num_guest,
                                    :room_type_id, :view_type, :amount, :price
  end

  def booking_params_to_new
    params.permit(:room_type_id, :view_type, :amount,
                  :num_guest, :price, :check_in, :check_out)
          .merge(full_name: current_user.full_name, email: current_user.email)
  end

  def save_booking
    ActiveRecord::Base.transaction do
      raise ActiveRecord::Rollback unless @booking.save

      true
    end
  end

  def create_booking
    @booking = current_user.bookings.build booking_params_to_create
    @booking.book_day = DateTime.now
  end
end
