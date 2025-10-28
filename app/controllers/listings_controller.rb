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

  private

  def listing_params
    params.require(:listing).permit(
      :title, :description, :address, :price_per_night, :max_guests,
      photos: [] # mehrere Bilder optional
    )
  end
end
