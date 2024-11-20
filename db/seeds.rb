require "faker"

puts "Emptying ACTIVITIES database..."
Activity.destroy_all

puts "Emptying USERS database..."
User.destroy_all

puts "Creating 5 users..."
for i in 1..5 do
  puts "Creating user #{i}"
  User.create(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    birth_date: Faker::Date.birthday(min_age: 18, max_age: 65),
    email: "user#{i}@gmail.com",
    password: "password"
  )
end

puts "Creating 5 activities..."
users = User.all
melb_locations = ["Carlton, Victoria", "Southbank, Victoria", "Melbourne, Victoria", "Docklands, Victoria", "Fitzroy, Victoria"]
activity_capacity = [10, 20, 30, 50, 100]
activities = ["pilates", "running", "swimming", "surfing", "yoga"]
puts "Creating activity 1"


activity_1_owner = users.sample
activity_1_location = melb_locations.sample
file_path_1 = Rails.root.join("app/assets/images/#{activities[0]}.jpg")
file_1 = File.open(file_path_1)
pilates = Activity.create(
  user: activity_1_owner,
  # Can change the title/description
  title: "#{activities[0].capitalize} with #{activity_1_owner.first_name}",
  category: activities[0],
  description: "Join us in #{activity_1_location} for #{activities[0]}",
  location: activity_1_location,
  # Start time this upcoming week
  # Faker timezone is UTC, so evening is equivalent to morning in Melbourne
  start: (Faker::Time.between_dates(from: Date.today + 1, to: Date.today + 7, period: :evening)).beginning_of_hour,
  # Duration range from 15min to 2hrs
  duration: rand(1..8) * 15,
  # Price range from free to $100
  price: rand(0..20) * 5,
  # Capacity range from 10 to unlimited
  capacity: activity_capacity.sample
)
pilates.photo.attach(io: file_1, filename: "#{activities[0]}.jpg", content_type: "image/png")
pilates.save
file_1.close

puts "DONE!"
