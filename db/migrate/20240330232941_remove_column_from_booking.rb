class RemoveColumnFromBooking < ActiveRecord::Migration[7.1]
  def change
    remove_column :bookings, :price
    remove_foreign_key :bookings, :rooms
    remove_column :bookings, :room_id
  end
end
