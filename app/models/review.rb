class Review < ApplicationRecord
  belongs_to :user
  belongs_to :listing

  validates :rating,  presence: true, inclusion: { in: 1..5 }
  validates :content, presence: true, length: { minimum: 2 }
end
