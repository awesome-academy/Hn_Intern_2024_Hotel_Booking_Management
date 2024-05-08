module Api::V1
  class BookingsController < ApiController
    include ActionController::HttpAuthentication::Token

    before_action :authenticate_user

    def index
      @q = @user.bookings.ransack(params[:q])
      @q.sorts = ["status asc", "id desc"] if @q.sorts.empty?
      pagination, bookings = pagy @q.result,
                                  items: Settings.digits.digit_3
      render json: {pagination:, bookings:}
    end

    def show
      booking = Booking.find(params[:id])
      render json: booking, status: :ok
    rescue ActiveRecord::RecordNotFound => e
      render json: {error: e.message}, status: :not_found
    end

    def create
      booking = @user.bookings.build booking_params
      booking.book_day = DateTime.now
      if booking.save
        render json: booking, status: :created
      else
        render json: booking.errors, status: :unprocessable_entity
      end
    end

    private
    def booking_params
      params.require(:booking).permit :note, :full_name, :email, :telephone,
                                      :check_in, :check_out, :num_guest,
                                      :room_type_id, :view_type, :amount, :price
    end
  end
end
