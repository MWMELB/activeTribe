require "faker"

puts "Emptying GROUP_USERS database..."
GroupUser.destroy_all

puts "Emptying GROUPS database..."
Group.destroy_all

puts "Emptying ACTIVITIES database..."
Activity.destroy_all

puts "Emptying USERS database..."
User.destroy_all

puts "Creating 5 users..."
for i in 1..5 do
  puts "Creating user #{i}"
  first = Faker::Name.first_name
  last = Faker::Name.last_name
  User.create(
    first_name: first.downcase,
    last_name: last.downcase,
    username: "#{first}_#{last}",
    birth_date: Faker::Date.birthday(min_age: 18, max_age: 65),
    email: "user#{i}@gmail.com",
    password: "password",
    terms: true
  )
end

puts "Creating 5 activities..."
users = User.all
melb_locations = ["Carlton, Victoria", "Southbank, Victoria", "Melbourne, Victoria", "Docklands, Victoria", "Fitzroy, Victoria"]
activity_capacity = [10, 20, 30, 50, 100]
activities = ["pilates", "running", "pickleball", "surfing", "basketball", "hike"]

activities.each_with_index do |activity, index|
  puts "Creating activity #{index + 1}"
  owner = users.sample
  location = melb_locations.sample
  file_path = Rails.root.join("app/assets/images/#{activity}.jpg")
  file = File.open(file_path)
  new_activity = Activity.create(
    user: owner,
    # Can change the title/description
    title: "#{activity.capitalize} with #{owner.first_name.capitalize}",
    category: activity,
    description: "Join us in #{location} for #{activity}",
    location: location,
    # Start time this upcoming week
    # Faker timezone is UTC, so evening is equivalent to morning in Melbourne
    start: (Faker::Time.between_dates(from: Date.today + 1, to: Date.today + 7, period: :evening)).beginning_of_hour,
    # Duration range from 15min to 2hrs
    duration: rand(1..8) * 15,
    # Price range from free to $100
    price: rand(0..20) * 5,
    # Capacity range from 10 to unlimited
    capacity: activity_capacity.sample,
    level: rand(0..2)
  )
  new_activity.photo.attach(io: file, filename: "#{activity}.jpg", content_type: "image/png")
  new_activity.save
  file.close

  if index.odd?
    puts "Creating group #{index}"
    Group.create(
      user: owner,
      name: "#{Faker::Team.creature} #{activity} club",
      description: "We love #{activity} 🤩"
    )
  end
end

puts "DONE!"
