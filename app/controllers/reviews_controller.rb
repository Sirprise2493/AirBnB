class ReviewsController < ApplicationController
  before_action :authenticate_user!

  def create
    @listing = Listing.find(params[:listing_id])
    @review  = current_user.reviews.new(review_params.merge(listing: @listing))

    if @review.save
      redirect_back fallback_location: listing_path(@listing, anchor: "reviews"),
                    notice: "Review saved!"
    else
      # If the form came from the profile, we can’t re-render listings/show with inline errors.
      if request.referer&.include?("/users")
        redirect_back fallback_location: user_profile_path,
                      alert: @review.errors.full_messages.to_sentence
      else
        # Listing page: keep your current inline error handling
        @reviews  = @listing.reviews.order(rating: :desc)
        @avg_rate = (@reviews.average(:rating) || 0).to_f.round(2)
        render "listings/show", status: :unprocessable_entity
      end
    end
  end

  private

  def review_params
    params.require(:review).permit(:rating, :content)
  end
end
