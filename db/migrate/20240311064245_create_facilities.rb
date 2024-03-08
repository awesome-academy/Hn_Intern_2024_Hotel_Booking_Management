class CreateFacilities < ActiveRecord::Migration[7.1]
  def change
    create_table :facilities do |t|
      t.string :name, null: false

      t.timestamps
    end
    add_index :facilities, :name
  end
end
