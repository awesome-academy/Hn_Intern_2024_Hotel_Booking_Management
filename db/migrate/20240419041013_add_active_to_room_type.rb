class AddActiveToRoomType < ActiveRecord::Migration[7.1]
  def change
    add_column :room_types, :status, :integer, default: 0
  end
end
