class AddProfileFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :bio, :text
    add_column :users, :location, :string
    add_column :users, :birthdate, :date
    add_column :users, :gender, :string
    add_column :users, :occupation, :string
    add_column :users, :languages, :string
  end
end
