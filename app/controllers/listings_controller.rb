class ListingsController < ApplicationController
  def index
  end

  def new
  end

  def create
  end

  def show
    @listing = Listing.find(params[:id])

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
