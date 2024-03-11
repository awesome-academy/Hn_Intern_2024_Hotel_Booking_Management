class CreateRoomFacilities < ActiveRecord::Migration[7.1]
  def change
    create_table :room_facilities do |t|
      t.references :room, null: false, foreign_key: true
      t.references :facility, null: false, foreign_key: true
      t.integer :quantity

      t.timestamps
    end
  end
end
