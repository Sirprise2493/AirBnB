class ListingsController < ApplicationController
  def index
  end

  def new
  end

  def create
  end

  def show
    @listing = Listing.includes(reviews: :user).find(params[:id])
    @reviews = @listing.reviews.order(rating: :desc)
    @avg_rate = (@reviews.average(:rating) || 0).to_f.round(2)

    # Create a review
    @review = Review.new
  end
end
