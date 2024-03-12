class RoomsController < ApplicationController
  before_action :load_room, only: :show
  def index
    @pagy, @rooms = pagy Room.desc_price, items: Settings.digits.digit_8
  end

  def show; end

  private
  def load_room
    @room = Room.find_by id: params[:id]
    return if @room

    flash[:warning] = t "flash.room_not_found"
    redirect_to root_path
  end
end
