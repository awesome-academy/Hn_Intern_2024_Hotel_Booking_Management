module Api::V1
  class RoomsController < ApiController
    include RoomsHelper

    def index
      pagination, rooms = pagy filtered_rooms,
                               {items: params.fetch(:limit, 3).to_i,
                                params: extra_params}
      render json: {pagination:, rooms:}, status: :ok
    end

    private
    def filtered_rooms
      default_dates
      RoomType.availabel_rooms(params[:check_in], params[:check_out])
              .public_send(params[:sort].presence || "latest")
              .filter_by_view_type(params[:view_type])
              .filter_by_room_type(params[:room_type])
              .filter_by_amount(params[:amount])
    end

    def default_dates
      params[:check_in] ||= (Date.current + 10.days).to_s
      params[:check_out] ||= (Date.current + 20.days).to_s
    end

    def extra_params
      params.permit(:room_type, :view_type, :sort, :check_in, :check_out,
                    :amount, :num_guest).to_h
    end
  end
end
