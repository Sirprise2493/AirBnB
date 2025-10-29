class CreateListings < ActiveRecord::Migration[7.1]
  def change
    create_table :listings do |t|
      t.string  :title,           null: false
      t.text    :description,     null: false
      t.string  :address,         null: false
      t.decimal :price_per_night, precision: 10, scale: 2, null: false
      t.integer :max_guests,      null: false

      t.timestamps
    end
    add_index :listings, :title
  end
end
