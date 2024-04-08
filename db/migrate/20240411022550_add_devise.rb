class AddDevise < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :encrypted_password, :string, null: false, default: ""
    add_column :users, :reset_password_token, :string
    add_column :users, :reset_password_sent_at, :datetime
    add_column :users, :remember_created_at, :datetime
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_sent_at, :datetime
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token,   unique: true

    remove_column :users, :password_digest
    remove_column :users, :activated
    remove_column :users, :activation_digest
    remove_column :users, :activated_at
    remove_column :users, :remember_digest
  end
end
