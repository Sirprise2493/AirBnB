class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user     = current_user
    @reviews_a  = @user.reviews.includes(:listing).order(created_at: :desc)
    avg       = @reviews_a.average(:rating) || 0
    @avg_rate = avg.to_f.round(2)
    @reviews = @reviews_a.page(params[:page]).per(6)

    @bookings = @user.bookings.order(created_at: :desc)

    @listing = @user.listings.new

    @listings = @user.listings.order(created_at: :desc)
  end
end
