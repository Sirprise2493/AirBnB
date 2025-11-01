class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :listing

  enum request_status: { pending: 0, accepted: 1, rejected: 2 }, _prefix: true

  validates :start_date, :end_date, presence: true
  validate  :end_after_start

  validates :total_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :review_rating, numericality: { only_integer: true, in: 1..5 }, allow_nil: true

  validates :number_guests, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validate :not_over_capacity

  before_validation :set_total_price, if: -> { listing && start_date && end_date }

  def nights
    return 0 unless start_date && end_date

    (end_date - start_date).to_i
  end

  private

  def end_after_start
    return if start_date.blank? || end_date.blank?

    errors.add(:end_date, "has to be after start date") if end_date <= start_date
  end

  def set_total_price
    self.total_price = nights * listing.price_per_night.to_d
  end

  def not_over_capacity
    return unless listing && number_guests.present?

    if number_guests > listing.max_guests
      errors.add(:number_guests, "must be ≤ #{listing.max_guests}")
    end
  end
end
