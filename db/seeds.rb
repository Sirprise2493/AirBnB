# db/seeds.rb
Booking.destroy_all
Review.destroy_all
Listing.destroy_all
User.destroy_all

puts "Creating users…"
u_host1 = User.create!(
  first_name: "Alice",
  last_name:  "Host",
  email:      "alice@example.com",
  password:   "secret123",
  role:       :host
)

u_guest1 = User.create!(
  first_name: "Bob",
  last_name:  "Guest",
  email:      "bob@example.com",
  password:   "secret123",
  role:       :guest
)

u_both = User.create!(
  first_name: "Carol",
  last_name:  "Both",
  email:      "carol@example.com",
  password:   "secret123",
  role:       :host
)

puts "Creating listings…"
l1 = Listing.create!(
  title:           "Cozy Old Building Apartment",
  description:     "Bright 2-room apartment near the city center.",
  address:         "Sample Street 1, 10115 Berlin",
  price_per_night: 89.00,
  max_guests:      2,
  user:            u_host1
)

l2 = Listing.create!(
  title:           "Loft with Rooftop Terrace",
  description:     "Modern loft with a large terrace and city view.",
  address:         "Example Way 20, 80331 Munich",
  price_per_night: 139.00,
  max_guests:      4,
  user:            u_both
)

l3 = Listing.create!(
  title:           "Small Studio by the Park",
  description:     "Quiet studio, perfect for short trips.",
  address:         "Park Avenue 7, 50667 Cologne",
  price_per_night: 69.00,
  max_guests:      2,
  user:            u_both
)

puts "Creating bookings…"
Booking.create!(
  user:           u_guest1,
  listing:        l1,
  start_date:     Date.today + 7,
  end_date:       Date.today + 10,
  request_status: :pending,
  total_price:    3 * l1.price_per_night
)

Booking.create!(
  user:           u_guest1,
  listing:        l2,
  start_date:     Date.today + 14,
  end_date:       Date.today + 17,
  request_status: :accepted,
  total_price:    3 * l2.price_per_night
)

Booking.create!(
  user:           u_guest1,
  listing:        l3,
  start_date:     Date.today + 21,
  end_date:       Date.today + 24,
  request_status: :rejected,
  total_price:    3 * l3.price_per_night
)

puts "Creating reviews…"
Review.create!(
  user:    u_guest1,
  listing: l1,
  rating:  5,
  content: "Super clean, great location!"
)

Review.create!(
  user:    u_guest1,
  listing: l2,
  rating:  4,
  content: "Amazing loft and terrace. Check-in could be smoother."
)

Review.create!(
  user:    u_guest1,
  listing: l3,
  rating:  3,
  content: "Good value, but very small."
)

puts "Seeding done."
puts "Users: #{User.count}, Listings: #{Listing.count}, Bookings: #{Booking.count}, Reviews: #{Review.count}"
