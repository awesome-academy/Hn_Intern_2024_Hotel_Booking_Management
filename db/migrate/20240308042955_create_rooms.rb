class CreateRooms < ActiveRecord::Migration[7.1]
  def change
    create_table :rooms do |t|
      t.string :name, null: false
      t.float :price, null: false
      t.text :description
      t.integer :room_type
      t.integer :view_type

      t.timestamps
    end
    add_index :rooms, :name, unique: true
  end
end
