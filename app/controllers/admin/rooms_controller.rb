class Admin::RoomsController < Admin::BaseController
  before_action :load_room, only: %i(show active_room inactive_room update)
  def index
    @q = Room.ransack params[:q]
    @q.sorts = ["created_at desc", "id asc"] if @q.sorts.empty?
    @pagy, @rooms = pagy @q.result, items: Settings.digits.digit_5
  end

  def show; end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new room_params
    if @room.save
      redirect_to admin_rooms_path, notice: t("flash.add_success")
    else
      flash[:alert] = t("flash.add_failed")
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @room.update room_params
      redirect_to request.referer || admin_rooms_path,
                  notice: t("flash.update_success")
    else
      redirect_to request.referer || admin_rooms_path,
                  alert: t("flash.update_failed")
    end
  end

  def active_room
    @room.active
    redirect_to request.referer || admin_rooms_path,
                notice: t("flash.activated")
  end

  def inactive_room
    if @room.can_be_inactive?
      @room.inactive
      redirect_to request.referer || admin_rooms_path,
                  notice: t("flash.inactivated")
    else
      redirect_to request.referer || admin_rooms_path,
                  alert: t("flash.room_is_busy")
    end
  end

  private
  def room_params
    params.require(:room).permit :name, :view_type, :room_type_id
  end
end
