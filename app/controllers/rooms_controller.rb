class RoomsController < ApplicationController
  before_action :load_room, only: %i(show check_available)
  def index
    @pagy, @rooms = pagy(
      request.get? ? Room.latest : filtered_rooms,
      items: Settings.digits.digit_8,
      params: request.get? ? nil : extra_params,
      link_extra: request.get? ? nil : "data-turbo-method=post"
    )
    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("show-list-rooms",
                                                  partial: "list_rooms")
      end
    end
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
  private

  def filtered_rooms
    Room.includes(:facilities)
        .filter_by_room_type(params[:room_type])
        .filter_by_view_type(params[:view_type])
        .available_in_priod(params[:check_in], params[:check_out])
        .send(params[:sort].presence || "latest")
  end

  def extra_params
    params.permit(:room_type, :view_type, :sort, :check_in, :check_out).to_h
  end
end
