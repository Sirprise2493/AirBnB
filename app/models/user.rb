class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :rememberable, :validatable

  has_many :listings,  dependent: :destroy
  has_many :bookings,  dependent: :destroy
  has_many :reviews,   dependent: :destroy
  enum role: { guest: 0, host: 1, admin: 2 }

  validates :first_name, :last_name, presence: true

  has_one_attached :photo
  
  # New addtions
  # ---------------
  def full_name
    [first_name, last_name].compact.join(" ")
  end

  def is_host?
    role == "host" || role == "admin"
  end

  def verified?
    email.present? && phone.present?
  end
  # ---------------
end
