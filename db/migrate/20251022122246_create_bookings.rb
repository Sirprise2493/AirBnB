class CreateBookings < ActiveRecord::Migration[7.1]
  def change
    create_table :bookings do |t|
      t.references :user,    null: false, foreign_key: true
      t.references :listing, null: false, foreign_key: true

      t.date    :start_date,     null: false
      t.date    :end_date,       null: false
      t.integer :request_status, null: false, default: 0
      t.decimal :total_price, precision: 10, scale: 2
      t.text    :review
      t.integer :review_rating

      t.timestamps
    end
    add_index :bookings, [:listing_id, :start_date, :end_date]
  end
end
