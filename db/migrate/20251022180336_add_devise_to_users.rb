class AddDeviseToUsers < ActiveRecord::Migration[7.1]
  def change
    change_column_null :users, :email, false
    add_index :users, :email, unique: true unless index_exists?(:users, :email)

    add_column :users, :encrypted_password, :string, null: false, default: ""
    add_column :users, :remember_created_at, :datetime

    remove_column :users, :password, :string if column_exists?(:users, :password)
  end
end
