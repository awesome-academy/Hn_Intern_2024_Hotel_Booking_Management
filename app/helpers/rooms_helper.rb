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
end
