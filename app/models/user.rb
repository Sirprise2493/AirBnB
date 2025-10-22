class User < ApplicationRecord
  has_many :listings,  dependent: :destroy
  has_many :bookings,  dependent: :destroy
  has_many :reviews,   dependent: :destroy

  enum role: { guest: 0, host: 1, admin: 2 }

  validates :first_name, :last_name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: /\A[^@\s]+@[^@\s]+\z/ }
  validates :password, presence: true, length: { minimum: 6 }

  has_one_attached :photo
end
