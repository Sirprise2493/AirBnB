class ListingsController < ApplicationController
  def index
    @listings = Listing.order(created_at: :desc)
  end

  # GET /listings/new
  def new
    @listing = current_user.listings.new
  end

  # POST /listings
  def create
    @listing = current_user.listings.new(listing_params)
    if @listing.save
      redirect_to user_profile_path, notice: "Listing created."
    else
      @user     = current_user
      @reviews  = @user.reviews.includes(:listing).order(created_at: :desc)
      avg       = @reviews.average(:rating) || 0
      @avg_rate = avg.to_f.round(2)
      @bookings = @user.bookings.order(created_at: :desc)
      # @listing enthält hier bereits die Fehler

      render "users/show", status: :unprocessable_entity
    end
  end

  def destroy
    @listing = Listing.find(params[:id])
    @listing.destroy
    redirect_to user_profile_path, status: :see_other
  end

  def show
    @listing = Listing.includes(reviews: :user).find(params[:id])

    base_scope = @listing.reviews
                        .includes(:user)
                        .order(rating: :desc)

    @avg_rate = (base_scope.reorder(nil).average(:rating) || 0).to_f.round(2)

    @reviews = base_scope.page(params[:page]).per(6)

    @review = Review.new

    # Geocoding
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
