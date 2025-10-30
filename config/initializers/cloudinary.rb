Cloudinary.config do |c|
  c.cloud_name = ENV["CLOUDINARY_CLOUD_NAME"]
  c.api_key    = ENV["CLOUDINARY_API_KEY"]
  c.api_secret = ENV["CLOUDINARY_API_SECRET"]
  c.secure     = true
end
