class DropRoomFacility < ActiveRecord::Migration[7.1]
  def change
    drop_table :room_facilities
  end
end
