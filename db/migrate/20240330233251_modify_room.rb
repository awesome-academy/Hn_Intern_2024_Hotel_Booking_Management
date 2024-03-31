class ModifyRoom < ActiveRecord::Migration[7.1]
  def change
    remove_column :rooms, :room_type
    remove_column :rooms, :price
    remove_column :rooms, :description
    add_reference :rooms, :room_type, foreign_key: true
  end
end
