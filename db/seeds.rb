require "faker"

puts "Emptying GROUP_COMMENTS database..."
GroupComment.destroy_all

puts "Emptying GROUP_POSTS database..."
GroupPost.destroy_all

puts "Emptying ACTIVITY_COMMENTS database..."
ActivityComment.destroy_all

puts "Emptying ACTIVITY_POSTS database..."
ActivityPost.destroy_all

puts "Emptying GROUP_USERS database..."
GroupUser.destroy_all

puts "Emptying GROUPS database..."
Group.destroy_all

puts "Emptying ACTIVITIES database..."
Activity.destroy_all

puts "Emptying USERS database..."
User.destroy_all

puts "Creating user Ivy Ta"
first = "ivy"
last = "ta"
file_path = Rails.root.join("app/assets/images/ivy.jpg")
file = File.open(file_path)
ivy = User.create(
  first_name: "Ivy",
  last_name: "Ta",
  username: "#{first.downcase}_#{last.downcase}",
  birth_date: Faker::Date.birthday(min_age: 18, max_age: 65),
  email: "ivy@gmail.com",
  password: "password",
  terms: true
)
ivy.photo.attach(io: file, filename: "ivy.jpg", content_type: "image/png")
ivy.save
file.close

puts "Creating user Harry Potter"
first = "harry"
last = "potter"
file_path = Rails.root.join("app/assets/images/harry.jpg")
file = File.open(file_path)
harry = User.create(
  first_name: "Harry",
  last_name: "Potter",
  username: "#{first.downcase}_#{last.downcase}",
  birth_date: Faker::Date.birthday(min_age: 18, max_age: 65),
  email: "harry@gmail.com",
  password: "password",
  terms: true
)
harry.photo.attach(io: file, filename: "harry.jpg", content_type: "image/png")
harry.save
file.close

puts "Creating user Simone Biles"
first = "Simone"
last = "Biles"
file_path = Rails.root.join("app/assets/images/simone.jpg")
file = File.open(file_path)
simone = User.create(
  first_name: "Simone",
  last_name: "Biles",
  username: "#{first.downcase}_#{last.downcase}",
  birth_date: Faker::Date.birthday(min_age: 18, max_age: 65),
  email: "simone@gmail.com",
  password: "password",
  terms: true
)
simone.photo.attach(io: file, filename: "simone.jpg", content_type: "image/png")
simone.save
file.close

puts "Creating 6 activities..."
users = User.all
melb_locations = ["Carlton, Victoria", "Southbank, Victoria", "Melbourne, Victoria", "Docklands, Victoria", "Fitzroy, Victoria"]
activity_capacity = [10, 15, 20, 30]
activities = ["pilates", "running", "pickleball", "surfing", "basketball", "hiking"]

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
    category: activity.capitalize,
    description: "Join us in #{location} for #{activity} #{Faker::Lorem.paragraph(sentence_count: 5)}",
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

  Booking.create(user: owner, activity: new_activity, status: :Accepted)

  if index.odd?
    puts "Creating group #{index}"
    file_path_group = Rails.root.join("app/assets/images/#{activity}-2.jpg")
    file = File.open(file_path_group)
    new_group = Group.create(
      user: owner,
      name: "#{Faker::Team.creature} #{activity} club",
      description: "We love #{activity} 🤩 #{Faker::Lorem.paragraph(sentence_count: 5)}"
    )
    new_group.photo.attach(io: file, filename: "#{activity}-2.jpg", content_type: "image/png")
    new_group.save
    file.close

    GroupUser.create(user: owner, group: new_group)
  end
end

puts "Creating Hiking at Grampians National Park"
file_path = Rails.root.join("app/assets/images/grampian.jpg")
file = File.open(file_path)
grampians = Activity.create(
  user: User.first,
  # Can change the title/description
  title: "Hiking at Grampians National Park",
  category: "Hiking",
  description: "Join us in Grampians National Park for Hiking! #{Faker::Lorem.paragraph(sentence_count: 5)}",
  location: "Grampians National Park",
  # Start time this upcoming week
  # Faker timezone is UTC, so evening is equivalent to morning in Melbourne
  start: Time.zone.now.change(hour: 17, min: 0, sec: 0),
  # Duration range from 15min to 2hrs
  duration: 120,
  # Price range from free to $100
  price: 0,
  # Capacity range from 10 to unlimited
  capacity: 10,
  level: 0
)
grampians.photo.attach(io: file, filename: "grampian.jpg", content_type: "image/png")
grampians.save
file.close
Booking.create(user: ivy, activity: grampians, status: :Accepted)

puts "creating Anti-tinder run club"
file_path = Rails.root.join("app/assets/images/anti-tinder.jpg")
file = File.open(file_path)
anti_tindr_group = Group.create(
  user: User.first,
  name: "Anti-tinder run club ",
  description: "We love running! 🤩 Not tinder through 👹 #{Faker::Lorem.paragraph(sentence_count: 5)}"
)
anti_tindr_group.photo.attach(io: file, filename: "anti-tinder.jpg", content_type: "image/png")
anti_tindr_group.save
file.close

GroupUser.create(user: ivy, group: anti_tindr_group)

puts "DONE!"
