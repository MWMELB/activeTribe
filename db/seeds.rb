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
melb_locations = ["Carlton", "Melbourne", "South Yarra", "Fitzroy", "Southbank"]
5.times do
  activity_owner = users.sample
  activity_type = Faker::Sport.sport(include_unusual: true)
  activity_location = melb_locations.sample
  Activity.create(
    user: activity_owner,
    title: "#{activity_type} with #{activity_owner.first_name}",
    sport: activity_type,
    description: "Join us in #{activity_location} for #{activity_type}",
    location: activity_location,
    start: (Faker::Time.between_dates(from: Date.today + 1, to: Date.today + 7, period: :evening)).beginning_of_hour,
    duration: rand(8) * 15,
    price: rand(0..20) * 5
  )
end

puts "DONE!"
