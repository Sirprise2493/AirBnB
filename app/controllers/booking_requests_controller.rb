class BookingRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_listing
  before_action :ensure_owner

def index
  @booking_requests = @listing.bookings
                              .includes(:user)
                              .order(created_at: :desc)
end

  private

  def set_listing
    @listing = Listing.find(params[:listing_id])
  end

  def update
  @booking = @listing.bookings.find(params[:id])
  case params[:status]
  when "accepted" then @booking.accepted!
  when "rejected" then @booking.rejected!
  else                 @booking.pending!
  end
redirect_to listing_booking_requests_path(@listing), notice: "Booking updated."
end

  def ensure_owner
    unless @listing.user == current_user
      redirect_to root_path, alert: "Not authorized"
    end
  end
end

