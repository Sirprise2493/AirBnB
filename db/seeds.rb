require "open-uri" # Required to open URLs when attaching photos
require "openssl"

# Disable SSL verification temporarily (safe for local development)
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

# -----------------------------------------------------------------------------
# Clean up (keep Users intact!)
# -----------------------------------------------------------------------------
puts "Cleaning up…"
Booking.destroy_all
Review.destroy_all
Listing.destroy_all
# User.destroy_all   # <- Do NOT destroy users; we rely on existing user IDs.

# -----------------------------------------------------------------------------
# Resolve users for listings and bookings
# -----------------------------------------------------------------------------
# We will use user id 1 and 3 as hosts to match your example, and try to pick
# a guest distinct from those.
def require_user(id)
  User.find(id)
rescue ActiveRecord::RecordNotFound
  abort "Required user with id=#{id} does not exist. Please create it first."
end

host1 = require_user(63) # owner for l1
host2 = require_user(63) # owner for l2 & l3

guest = User.where.not(id: [host1.id, host2.id]).first
abort "No guest user available (need any user not id #{host1.id}/#{host2.id})." unless guest

# -----------------------------------------------------------------------------
# Create listings (reproducible)
# -----------------------------------------------------------------------------
puts "Creating listings…"
l1 = Listing.create!(
  title:           "Cozy Old Building Apartment",
  description:     "Bright 2-room apartment near the city center.",
  address:         "Sample Street 1, 10115 Berlin",
  price_per_night: 89.00,
  max_guests:      2,
  user:            host1
)

l2 = Listing.create!(
  title:           "Loft with Rooftop Terrace",
  description:     "Modern loft with a large terrace and city view.",
  address:         "Example Way 20, 80331 Munich",
  price_per_night: 139.00,
  max_guests:      4,
  user:            host2
)

l3 = Listing.create!(
  title:           "Small Studio by the Park",
  description:     "Quiet studio, perfect for short trips.",
  address:         "Park Avenue 7, 50667 Cologne",
  price_per_night: 69.00,
  max_guests:      2,
  user:            host2
)

l4 = Listing.create!(
  title:           "Scandinavian Cabin Getaway",
  description:     "Minimalist wooden cabin surrounded by nature.",
  address:         "Lapland, Sweden",
  price_per_night: 150.00,
  max_guests:      4,
  user:            host1
)

l5 = Listing.create!(
  title:           "Beachfront Bungalow",
  description:     "Wake up to the sound of waves and sea breeze.",
  address:         "Comporta, Portugal",
  price_per_night: 200.00,
  max_guests:      5,
  user:            host2
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

# -----------------------------------------------------------------------------
# Create example bookings
# -----------------------------------------------------------------------------
puts "Creating bookings…"
Booking.create!(
  user:           guest,
  listing:        l1,
  start_date:     Date.today + 7,
  end_date:       Date.today + 10,
  request_status: :pending,
  number_guests:  2,
  total_price:    3 * l1.price_per_night
)

Booking.create!(
  user:           guest,
  listing:        l2,
  start_date:     Date.today + 14,
  end_date:       Date.today + 17,
  request_status: :accepted,
  number_guests:  3,
  total_price:    3 * l2.price_per_night
)

Booking.create!(
  user:           guest,
  listing:        l3,
  start_date:     Date.today + 21,
  end_date:       Date.today + 24,
  request_status: :rejected,
  number_guests:  2,
  total_price:    3 * l3.price_per_night
)

# -----------------------------------------------------------------------------
# Seed baseline example reviews from the guest (optional flavor)
# -----------------------------------------------------------------------------
puts "Creating baseline reviews…"
Review.create!(
  user:    guest,
  listing: l1,
  rating:  5,
  content: "Super clean, great location!"
)

Review.create!(
  user:    guest,
  listing: l2,
  rating:  4,
  content: "Amazing loft and terrace. Check-in could be smoother."
)

Review.create!(
  user:    guest,
  listing: l3,
  rating:  3,
  content: "Good value, but very small."
)

# -----------------------------------------------------------------------------
# Bulk review seeding rules:
# - User with id=6 must have at least 7 reviews per listing.
# - All other users (excluding the listing owner and user 6) should have 1–2
#   reviews per listing (if they don't already).
# - This block is idempotent: it *tops up* counts, avoids duplicates, and is
#   safe to run multiple times.
# -----------------------------------------------------------------------------
puts "Seeding rule-based reviews…"

u6 = User.find_by(id: 6)
abort "User with id=6 does not exist. Please create it first." unless u6

review_phrases = [
  "Super clean and great location.",
  "Exactly as described.",
  "Smooth check-in.",
  "Very friendly host.",
  "Would happily stay again.",
  "Good value for money.",
  "Some minor issues, but overall fine.",
  "Well-equipped place.",
  "Quiet neighborhood.",
  "Fast Wi-Fi and comfy beds."
]

def random_content(phrases, i: nil)
  base = phrases.sample
  i ? "#{base} (##{i})" : base
end

total_created = 0
listings = [l1, l2, l3]

listings.each do |listing|
  # --- Part A: user 6 => ensure >= 7 reviews per listing
  existing = Review.where(user_id: u6.id, listing_id: listing.id).count
  needed = [0, 7 - existing].max

  needed.times do |i|
    rating  = (i + existing) % 5 + 1 # 1..5 cycling
    content = random_content(review_phrases, i: existing + i + 1)
    begin
      Review.create!(
        user:    u6,
        listing: listing,
        rating:  rating,
        content: content
      )
      total_created += 1
    rescue ActiveRecord::RecordInvalid => e
      puts "Skipped (user 6, listing #{listing.id}): #{e.record.errors.full_messages.join(', ')}"
    end
  end

  # --- Part B: other users => add 1–2 per listing (no owner, no user 6)
  candidate_users = User.where.not(id: [u6.id, listing.user_id]).to_a
  # Exclude users who already reviewed this listing
  candidate_users.reject! { |u| Review.exists?(user_id: u.id, listing_id: listing.id) }

  to_take = [[candidate_users.size, rand(1..2)].min, 0].max
  candidate_users.sample(to_take).each_with_index do |u, j|
    rating  = [[3 + j, 5].min, 1].max # tends to 3..5
    content = random_content(review_phrases)
    begin
      Review.create!(
        user:    u,
        listing: listing,
        rating:  rating,
        content: content
      )
      total_created += 1
    rescue ActiveRecord::RecordInvalid => e
      puts "Skipped (user #{u.id}, listing #{listing.id}): #{e.record.errors.full_messages.join(', ')}"
    end
  end
end

puts "Review seeding complete."
puts "Newly created reviews: #{total_created}"
puts "Summary — Users: #{User.count}, Listings: #{Listing.count}, Bookings: #{Booking.count}, Reviews: #{Review.count}"

# -----------------------------------------------------------------------------
# Notes:
# - If you want to strictly prevent multiple reviews by the same user on the
#   same listing, add this to your Review model and migration:
#
#   # app/models/review.rb
#   # validates :user_id, uniqueness: { scope: :listing_id }
#
#   # db migration (change your existing index)
#   # add_index :reviews, [:listing_id, :user_id], unique: true
# -----------------------------------------------------------------------------
