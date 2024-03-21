class BookingsController < ApplicationController
  before_action :signed_in_user
  before_action :load_room, only: :new
  before_action :load_booking, only: %i(show destroy)
  before_action :create_booking, only: :create

  def index
    @pagy, @bookings = pagy current_user.get_bookings,
                            items: Settings.digits.digit_3
  end

  def show
    render turbo_stream:
      turbo_stream.replace("show-detail-booking",
                           partial: "detail",
                           locals: {booking: @booking})
  end

  def new
    @booking = @room.bookings.build
  end

  def create
    if save_booking
      flash[:success] = t ".flash_create_success"
      redirect_to root_path
    else
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
  def booking_params
    params.require(:booking).permit :full_name, :email, :telephone,
                                    :check_in, :check_out, :note, :price,
                                    :room_id
  end

  def save_booking
    ActiveRecord::Base.transaction do
      raise ActiveRecord::Rollback unless @booking.save

      true
    end
  end

  def create_booking
    @room = Room.find_by id: params.dig(:booking, :room_id)
    @booking = @room.bookings.build booking_params
    @booking.user = current_user
    @booking.book_day = DateTime.now
  end
end
