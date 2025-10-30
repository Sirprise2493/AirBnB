class BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_listing, only: :create
  before_action :set_booking, only: [:show, :destroy]
  before_action :authorize_booking!, only: [:show, :destroy]

  def create
    @booking = current_user.bookings.new(booking_params.merge(listing: @listing))

    if @booking.save
      redirect_to @listing, notice: "Created booking"
    else
      render "listings/show", status: :unprocessable_entity
    end
  end

  def show
    # @booking is set from set_booking
  end

  def destroy
    @booking.destroy
    redirect_back fallback_location: user_profile_path, status: :see_other, notice: "Booking deleted"
  end

  private

  def set_listing
    @listing = Listing.find(params[:listing_id])
  end

  def set_booking
    @booking = Booking.find(params[:id])
  end

  def authorize_booking!
    head :forbidden unless @booking.user_id == current_user.id
  end

  def booking_params
    params.require(:booking).permit(:start_date, :end_date, :number_guests)
  end
end
