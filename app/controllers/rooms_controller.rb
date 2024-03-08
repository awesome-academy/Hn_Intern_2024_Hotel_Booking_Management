class RoomsController < ApplicationController
  def index
    @pagy, @rooms = pagy Room.all, items: Settings.digits.digit_8
  end
end
