class Admin::BookingsController < Admin::BaseController
  def index
    @pagy, @bookings = pagy Booking.newest,
                            items: Settings.digits.digit_5
  end
end
