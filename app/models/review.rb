class Review < ApplicationRecord
  belongs_to :user
  belongs_to :listing

  validates :rating,  numericality: { only_integer: true, in: 1..5 }
  validates :content, presence: true
end
