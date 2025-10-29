class BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_listing, only: [:create, :show]

  def create
    @booking = current_user.bookings.new(booking_params.merge(listing: @listing))

    if @booking.save
      redirect_to @listing, notice: "Created booking"
    else
      render "listings/show", status: :unprocessable_entity
    end
  end

  def show
  end

  private

  def set_listing
    @listing = Listing.find(params[:listing_id])
  end

  # strong params – only allowed params; user/listing is set on server site
  def booking_params
    params
      .require(:booking)
      .permit(:start_date, :end_date)
  end
end
