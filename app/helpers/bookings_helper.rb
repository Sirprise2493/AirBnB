module BookingsHelper
  # Map enum-ish status to Bootstrap badge colors
  def booking_status_badge(booking)
    status = booking.request_status.to_s # works if it's an enum
    case status
    when "pending"   then ["Pending",  "warning"]
    when "accepted", "approved", "confirmed" then ["Confirmed", "success"]
    when "declined", "rejected", "canceled", "cancelled" then ["Declined", "danger"]
    else [status.titleize, "secondary"]
    end
  end
end
