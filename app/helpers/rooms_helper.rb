module RoomsHelper
  def room_type_options
    Room.room_types.map{|k, v| [t(k), v]}
  end

  def view_type_options
    Room.view_types.map{|k, v| [t(k), v]}
  end

  def sort_options
    [
      [t(".asc_price"), "asc_price"],
      [t(".desc_price"), "desc_price"],
      [t(".asc_name"), "asc_name"],
      [t(".desc_name"), "desc_name"],
      [t(".latest"), "latest"]
    ]
  end
end
