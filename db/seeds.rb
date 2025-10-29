require "open-uri" # Required to open URLs when attaching photos

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

l4 = Listing.create!(
  title:           "Scandinavian Cabin Getaway",
  description:     "Minimalist wooden cabin surrounded by nature.",
  address:         "Lapland, Sweden",
  price_per_night: 150.00,
  max_guests:      4,
  user:            u_host1
)

l5 = Listing.create!(
  title:           "Beachfront Bungalow",
  description:     "Wake up to the sound of waves and sea breeze.",
  address:         "Comporta, Portugal",
  price_per_night: 200.00,
  max_guests:      5,
  user:            u_both
)

puts "Attaching photos to listings..."

set1 = [
  "https://plus.unsplash.com/premium_photo-1680028256635-17e7f3ebbb23?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=2069",
  "https://plus.unsplash.com/premium_photo-1680296669199-19fd3acbabc3?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=987",
  "https://images.unsplash.com/photo-1642723978517-8955e5f3138f?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=986",
  "https://plus.unsplash.com/premium_photo-1736194026187-39e23ae676e0?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=987",
  "https://images.unsplash.com/photo-1755829634812-77614455c061?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=2070"
]

set2 = [
  "https://images.unsplash.com/photo-1596480823522-b9827f1fe2d2?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=1974",
  "https://plus.unsplash.com/premium_photo-1684175656172-19a7ee56f0c8?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=987",
  "https://plus.unsplash.com/premium_photo-1684175656280-c80e797c63a7?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=2070"
]

set3 = [
  "https://images.unsplash.com/photo-1725891259301-1ecfb46433b6?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8c21hbGwlMjBmbGF0fGVufDB8fDB8fHww&auto=format&fit=crop&q=60&w=900",
  "https://plus.unsplash.com/premium_photo-1676321046449-3acb3cd47e81?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=2070",
  "https://plus.unsplash.com/premium_photo-1663076153319-e65d2ec746cf?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=2070s"
]

set4 = [
  "https://plus.unsplash.com/premium_photo-1687996107399-9b68475e365c?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=2070",
  "https://images.unsplash.com/photo-1630184604932-665d42cfcc69?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=2052",
  "https://images.unsplash.com/photo-1733426107854-ee00a25d72a7?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=1583",
  "hhttps://images.unsplash.com/photo-1556020685-ae41abfc9365?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=987",
  "https://plus.unsplash.com/premium_photo-1684506394101-09b0ef6c238c?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=2070"
]

set5 = [
  "https://plus.unsplash.com/premium_photo-1724659217647-4bfdba75e5a6?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=2070",
  "https://plus.unsplash.com/premium_photo-1686090448331-206895954c61?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=987",
  "https://plus.unsplash.com/premium_photo-1683649964203-baf13fa852e4?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=2070",
  "https://images.unsplash.com/photo-1584132915807-fd1f5fbc078f?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=2070",
  "https://images.unsplash.com/photo-1658595148900-c77873724e98?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=2070"
]

# Helper method to attach photos from URLs to a listing

# Attach remote photos from given URLs to a listing.
# Streams images directly to Cloudinary through Active Storage.
def attach_photos(listing, urls)
  urls.each_with_index do |url, idx|
    begin
      puts "→ Uploading image #{idx + 1} for #{listing.title} to Cloudinary..."
      
      # Open the remote file as a read-only stream (no local temp file)
      file = URI.open(url)

      # Attach it directly via Active Storage (Cloudinary handles hosting)
      listing.photos.attach(
        io: file,
        filename: "listing-#{listing.id}-#{idx + 1}.jpg",
        content_type: "image/jpeg"
      )

      # It’s good practice to close the stream once uploaded
      file.close

    rescue OpenURI::HTTPError => e
      puts "⚠️ Skipped photo #{idx + 1} for #{listing.title}: URL not found (#{e.message})"
    rescue => e
      puts "⚠️ Failed to attach photo #{idx + 1} for #{listing.title}: #{e.class} - #{e.message}"
    end
  end
end

# Attach photos to each listing

attach_photos(l1, set1)
attach_photos(l2, set2)
attach_photos(l3, set3)
attach_photos(l4, set4)
attach_photos(l5, set5)

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
