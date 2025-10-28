class Listing < ApplicationRecord
  #Geocoding
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  belongs_to :user
  has_many   :bookings, dependent: :destroy
  has_many   :reviews,  dependent: :destroy

  validates :title, :description, :address, presence: true
  validates :price_per_night, numericality: { greater_than: 0 }
  validates :max_guests, numericality: { only_integer: true, greater_than: 0 }

  has_many_attached :photos
end
