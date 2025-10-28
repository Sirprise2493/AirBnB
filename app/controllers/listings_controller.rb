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

    @markers =
      if @listing.geocoded?
        [{
          lat: @listing.latitude,
          lng: @listing.longitude,
          info_window_html: render_to_string(
            partial: "listings/geocoding/info_window",
            formats: [:html],
            locals: { listing: @listing },
            layout: false
          )
        }]
      else
        []
      end
  end
end
