class ReviewsController < ApplicationController
  before_action :authenticate_user!

  def create
    @listing = Listing.find(params[:listing_id])
    @review  = @listing.reviews.new(review_params)
    @review.user = current_user

    if @review.save
      redirect_to listing_path(@listing, anchor: "reviews"), notice: "Review saved!"
    else
      @reviews  = @listing.reviews.order(rating: :desc)
      @avg_rate = (@reviews.average(:rating) || 0).to_f.round(2)
      render "listings/show", status: :unprocessable_entity
    end
  end

  private
  def review_params
    params.require(:review).permit(:rating, :content)
  end
end
