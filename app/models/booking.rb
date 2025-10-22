class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :listing

  enum request_status: { pending: 0, accepted: 1, rejected: 2 }

  validates :start_date, :end_date, presence: true
  validate  :end_after_start

  validates :total_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :review_rating, numericality: { only_integer: true, in: 1..5 }, allow_nil: true

  private

  def end_after_start
    return if start_date.blank? || end_date.blank?
    errors.add(:end_date, "has to be after start date") if end_date <= start_date
  end
end
