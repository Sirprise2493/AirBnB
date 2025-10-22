class AddUserRefToListings < ActiveRecord::Migration[7.1]
  def change
    add_reference :listings, :user, null: false, foreign_key: true
  end
end
