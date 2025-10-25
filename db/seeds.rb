# db/seeds.rb

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

host1 = require_user(1) # owner for l1
host2 = require_user(3) # owner for l2 & l3

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
  total_price:    3 * l1.price_per_night
)

Booking.create!(
  user:           guest,
  listing:        l2,
  start_date:     Date.today + 14,
  end_date:       Date.today + 17,
  request_status: :accepted,
  total_price:    3 * l2.price_per_night
)

Booking.create!(
  user:           guest,
  listing:        l3,
  start_date:     Date.today + 21,
  end_date:       Date.today + 24,
  request_status: :rejected,
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
