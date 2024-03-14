class CreateBookings < ActiveRecord::Migration[7.1]
  def change
    create_table :bookings do |t|
      t.datetime :book_day, null: false
      t.string :note
      t.integer :status, null:false, default: 0
      t.string :message
      t.references :user, null: false, foreign_key: true
      t.string :full_name, null: false
      t.string :email, null: false
      t.string :telephone, null: false
      t.datetime :check_in, null: false
      t.datetime :check_out, null:false
      t.references :room, null: false, foreign_key: true
      t.float :price

      t.timestamps
    end
    add_index :bookings, [:user_id, :created_at]
  end
end
