class Admin::RoomTypesController < Admin::BaseController
  before_action :load_room_type, only: %i(show active inactive update)

  def index
    @q = RoomType.ransack params[:q]
    @q.sorts = ["id asc"] if @q.sorts.empty?
    @pagy, @room_types = pagy @q.result, items: Settings.digits.digit_5
  end

  def active
    @room_type.active
    redirect_to request.referer || admin_room_types_path,
                notice: t("flash.activated")
  end

  def inactive
    if @room_type.can_be_inactive?
      @room_type.inactive
      redirect_to request.referer || admin_room_types_path,
                  notice: t("flash.inactivated")
    else
      redirect_to request.referer || admin_room_types_path,
                  alert: t("flash.some_room_is_busy")
    end
  end

  def remove_image
    @image = ActiveStorage::Attachment.find_by id: params[:id]
    @image.purge_later
    redirect_back(fallback_location: admin_room_types_path)
  end

  def show
    @facilities = Facility.asc_name
  end

  def update
    if @room_type.update room_type_params
      redirect_to request.referer || admin_room_types_path,
                  notice: t("flash.update_success")
    else
      redirect_to request.referer || admin_room_types_path,
                  alert: t("flash.update_failed")
    end
  end

  private
  def load_room_type
    @room_type = RoomType
                 .with_attached_images
                 .includes(:facilities, :rooms)
                 .find_by id: params[:id]
    return if @room_type

    flash[:warning] = t "flash.room_not_found"
    redirect_to admin_room_types_path
  end

  def room_type_params
    params.require(:room_type)
          .permit(images: [], facility_ids: [])
  end
end
