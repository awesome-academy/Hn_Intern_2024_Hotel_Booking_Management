class AddActiveToRoom < ActiveRecord::Migration[7.1]
  def change
    add_column :rooms, :status, :integer, default: 0
  end
end
