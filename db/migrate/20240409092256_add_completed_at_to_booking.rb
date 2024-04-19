class AddCompletedAtToBooking < ActiveRecord::Migration[7.1]
  def change
    add_column :bookings, :completed_at, :datetime
  end
end
