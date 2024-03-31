class AddColumnToBooking < ActiveRecord::Migration[7.1]
  def change
    add_column :bookings, :num_guest, :integer
    add_column :bookings, :room_type_id, :integer, null: false
    add_column :bookings, :view_type, :integer, null: false
    add_column :bookings, :amount, :integer, null: false
    add_column :bookings, :price, :float
  end
end
