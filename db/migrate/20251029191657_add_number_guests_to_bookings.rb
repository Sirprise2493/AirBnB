class AddNumberGuestsToBookings < ActiveRecord::Migration[7.1]
  def change
    add_column :bookings, :number_guests, :integer, null: false, default: 1
  end
end
