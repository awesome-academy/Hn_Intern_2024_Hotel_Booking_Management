class CreateRoomTypeFacilities < ActiveRecord::Migration[7.1]
  def change
    create_table :room_type_facilities do |t|
      t.references :facility, null: false, foreign_key: true
      t.references :room_type, null: false, foreign_key: true

      t.timestamps
    end
  end
end
