class ListingsController < ApplicationController
  def index
    @listings = Listing.order(created_at: :desc)
  end

  # GET /listings/new
  def new
    @listing = Listing.new
  end

  # POST /listings
  def create
    @listing = current_user.listings.new(listing_params)
    if @listing.save
      redirect_to listings_path, notice: "Listing created."
    else
      render :new, status: :unprocessable_entity
    end
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
    
  private

  def listing_params
    params.require(:listing).permit(
      :title, :description, :address, :price_per_night, :max_guests,
      photos: [] # mehrere Bilder optional
    )
  end 
end
