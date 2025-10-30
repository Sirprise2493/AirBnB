module BookingsHelper
  # Adjust the cases to match your enum names if different.
  def booking_status_badge(booking)
    status_str =
      if booking.respond_to?(:request_status_before_type_cast) && booking.class.defined_enums["request_status"]
        booking.request_status # enum string
      else
        booking.request_status.to_s
      end

    case status_str
    when "pending"                         then ["Pending",   "warning"]
    when "accepted", "approved", "confirmed" then ["Confirmed", "success"]
    when "declined", "rejected", "canceled", "cancelled" then ["Declined", "danger"]
    else [status_str.to_s.titleize, "secondary"]
    end
  end
end
