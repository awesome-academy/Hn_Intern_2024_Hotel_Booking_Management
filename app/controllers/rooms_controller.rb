class RoomsController < ApplicationController
  before_action :load_room, only: %i(show check_available)

  def index
    if request.get? || params[:check_in].blank? || params[:check_out].blank?
      return respond_to(&:html)
    end

    @pagy, @room_types = pagy filtered_rooms, pagination_options
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("show-list-rooms",
                                                  partial: "list_rooms",
                                                  locals: keep_params)
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
    RoomType.availabel_rooms(params[:check_in], params[:check_out])
            .public_send(params[:sort].presence || "latest")
            .filter_by_view_type(params[:view_type])
            .filter_by_room_type(params[:room_type])
            .filter_by_amount(params[:amount])
  end

  def extra_params
    params.permit(:room_type, :view_type, :sort, :check_in, :check_out,
                  :amount, :num_guest).to_h
  end

  def keep_params
    params.permit(:check_in, :check_out, :num_guest).to_h
  end

  def pagination_options
    {
      items: Settings.digits.digit_3,
      params: extra_params,
      link_extra: "data-turbo-method=post"
    }
  end
end
