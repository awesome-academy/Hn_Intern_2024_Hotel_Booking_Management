class RenameMessageToReasonInBookings < ActiveRecord::Migration[7.1]
  def change
    rename_column :bookings, :message, :reason
  end
end
