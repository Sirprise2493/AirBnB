class BookingsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create, :index, :show]

  def index
    @bookings = current_user ? current_user.bookings.includes(:listing) : Booking.includes(:listing).all
  end

 def new
  start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : Date.new(2026, 7, 15)
  end_date   = params[:end_date].present? ? Date.parse(params[:end_date])   : Date.new(2026, 7, 19)

  @listing = OpenStruct.new( #temp
    id: 1,
    title: "Name_title_listing",
    price_per_night: 4.01, 
    max_guests: 4, 
    reviews: [],
    user: OpenStruct.new(first_name: "Name_Host")
  )

  @booking = Booking.new(
    start_date: start_date,
    end_date: end_date,
    total_price: 0.00,
    listing_id: @listing.id
  )

  @nights  = (end_date - start_date).to_i
  @nightly = @listing.price_per_night
  @total   = @booking.total_price
end


  def create
    @booking = Booking.new(booking_params)
    @booking.user    = current_user || User.first
    @booking.listing = Listing.first if @booking.listing_id.blank?

    if @booking.save
      redirect_to booking_path(@booking)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @booking = Booking.find(params[:id])
  end

  private

  def booking_params
    params.require(:booking).permit(:start_date, :end_date, :total_price, :listing_id)
  end
end
