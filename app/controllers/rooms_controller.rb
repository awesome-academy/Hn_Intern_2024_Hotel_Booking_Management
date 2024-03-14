class RoomsController < ApplicationController
  before_action :load_room, only: %i(show check_available)
  def index
    @pagy, @rooms = pagy Room.desc_price, items: Settings.digits.digit_8
  end

  def show; end

  def check_available
    check_in_date = params.dig(:date_check, :check_in_date)
    check_out_date = params.dig(:date_check, :check_out_date)
    if @room.available?(check_in_date, check_out_date)
      render(
        json: {
          message: t(".available_room", ci: check_in_date, co: check_out_date)
        },
        status: :ok
      )
    else
      render(
        json: {
          message: t(".busy_room", ci: check_in_date, co: check_out_date)
        },
        status: :not_found
      )
    end
  end
end
