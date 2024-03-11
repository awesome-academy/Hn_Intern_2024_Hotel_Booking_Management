class RoomsController < ApplicationController
  def index
    @pagy, @rooms = pagy Room.desc_price, items: Settings.digits.digit_8
  end
end
