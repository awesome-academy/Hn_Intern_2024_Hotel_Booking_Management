class CreateRoomTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :room_types do |t|
      t.string :name, null: false
      t.string :description
      t.float :price, null: false
      t.integer :num_of_bed
      t.integer :size_of_bed

      t.timestamps
    end
  end
end
