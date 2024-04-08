class Admin::BookingsController < Admin::BaseController
  before_action :load_booking, only: %i(show update)
  before_action :load_availabel_rooms, only: :show

  def index
    @q = Booking.ransack(params[:q])
    @q.sorts = ["status asc", "id desc"] if @q.sorts.empty?
    @pagy, @bookings = pagy @q.result,
                            items: Settings.digits.digit_8
  end

  def show; end

  def update
    case params[:status]
    when "completed"
      update_to_completed
    when "confirmed"
      update_to_confirmed
    else
      update_booking
    end
  end

  private
  def booking_params
    params.require(:booking).permit :status, :reason
  end

  def load_availabel_rooms
    @availabel_rooms = Room.availabel(@booking.check_in, @booking.check_out)
                           .filter_by_room_type_id(@booking.room_type_id)
                           .filter_by_view_type(@booking.view_type)
  end

  def update_to_completed
    @booking.update status: "completed"
    flash[:success] = t ".flash_update_success"
    redirect_to admin_bookings_path
  end

  def update_to_confirmed
    assigned_rooms = params[:assigned_rooms].drop(1)
    if assigned_rooms.length == @booking.amount
      ActiveRecord::Base.transaction do
        assign_rooms assigned_rooms
        @booking.status = "confirmed"
        @booking.save!
        @booking.send_mail_booking
      end
      flash[:success] = t ".flash_update_success"
      redirect_to admin_bookings_path
    else
      render_show_and_flash_now t ".incorrect_num_of_assigned_room"
    end
  rescue StandardError => e
    render_show_and_flash_now e.message
  end

  def render_show_and_flash_now msg
    flash.now[:danger] = msg
    load_availabel_rooms
    render :show, status: :unprocessable_entity
  end

  def assign_rooms assigned_rooms
    assigned_rooms.each do |room_id|
      room = Room.find_by id: room_id
      unless room.try(:can_be_assigned?, @booking.check_in, @booking.check_out)
        raise ActiveRecord::RecordInvalid,
              t(".room_is_ordered", name: room.name)
      end

      @booking.booked_rooms.create room_id:
    end
  end

  def update_booking
    if @booking.update booking_params
      flash[:success] = t ".flash_update_success"
      @booking.send_mail_booking
      redirect_to admin_bookings_path
    else
      @booking.reload
      load_availabel_rooms
      flash[:danger] = t ".flash_update_danger"
      render :show, status: :unprocessable_entity
    end
  end
end
