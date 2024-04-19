class CreateReviews < ActiveRecord::Migration[7.1]
  def change
    create_table :reviews do |t|
      t.references :booking, null: false, foreign_key: true
      t.integer :rating, null: false, default: 5
      t.string :comment, null: false
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
