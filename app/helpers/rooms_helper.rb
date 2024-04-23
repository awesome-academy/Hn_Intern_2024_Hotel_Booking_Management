module RoomsHelper
  def room_type_options
    RoomType.pluck(:name).map{|k| [t(k), k]}
  end

  def room_type_id_options
    RoomType.pluck(:id, :name).map{|id, name| [t(name), id]}
  end

  def view_type_options
    Room.view_types.map{|k, v| [t(k), v]}
  end

  def view_type_options_for_save
    Room.view_types.map{|k, _v| [t(k), k]}
  end

  def sort_options
    [
      [t(".asc_price"), "asc_price"],
      [t(".desc_price"), "desc_price"],
      [t(".latest"), "latest"]
    ]
  end

  def view_type_name view_type
    Room.view_types.key(view_type)
  end

  def active_status_options
    Room.statuses.map{|k, v| [t(k), v]}
  end

  def show_tag_status_room status
    case status
    when "active"
      content_tag(:span, t(status),
                  class: "badge bg-success rounded-pill fs-5")
    when "inactive"
      content_tag(:span, t(status),
                  class: "badge bg-danger rounded-pill fs-5")
    end
  end

  def show_button_status_room room
    case room.status
    when "active"
      link_to inactive_room_admin_room_path(room),
              class: "btn btn-danger rounded-pill",
              data: {turbo_method: :post} do
        fa_icon "lock"
      end
    when "inactive"
      link_to active_room_admin_room_path(room),
              class: "btn btn-outline-success rounded-pill",
              data: {turbo_method: :post} do
        fa_icon "unlock"
      end
    end
  end
end
