module RoomTypesHelper
  def size_of_bed_options
    RoomType.size_of_beds.map{|k, v| [t("bed_type.#{k}"), v]}
  end

  def size_of_bed_options_for_save
    RoomType.size_of_beds.map{|k, _v| [t("bed_type.#{k}"), k]}
  end

  def show_button_status_room_type room_type
    case room_type.status
    when "active"
      link_to admin_inactive_room_type_path(room_type),
              class: "btn btn-danger rounded-pill",
              data: {turbo_method: :post} do
        fa_icon "lock"
      end
    when "inactive"
      link_to admin_active_room_type_path(room_type),
              class: "btn btn-outline-success rounded-pill",
              data: {turbo_method: :post} do
        fa_icon "unlock"
      end
    end
  end
end
