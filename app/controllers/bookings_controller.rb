class BookingsController < ApplicationController
  before_action :signed_in_user, only: %i(new create)
  before_action :load_room, only: :new

  def index; end

  def show; end

  def new
    @booking = @room.bookings.build
  end

  def create # rubocop:disable Metrics/AbcSize
    @room = Room.find_by id: params.dig(:booking, :room_id)
    @booking = @room.bookings.build booking_params
    @booking.user = current_user
    @booking.book_day = Time.zone.today

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

  def destroy; end

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
end
