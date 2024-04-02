class CreateBookedRooms < ActiveRecord::Migration[7.1]
  def change
    create_table :booked_rooms do |t|
      t.references :room, null: true, foreign_key: true
      t.references :booking, null: false, foreign_key: true

      t.timestamps
    end
  end
end
