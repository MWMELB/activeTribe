class Activity < ApplicationRecord
  belongs_to :user
  has_many :bookings, dependent: :destroy
  has_many :activity_comments, dependent: :destroy
  has_many :bookers, through: :bookings, source: :user
  has_one_attached :photo
  validates :title, :category, :description, :location, :start, :duration, :price, :capacity, :level, presence: true
  geocoded_by :location
  after_validation :geocode, if: :will_save_change_to_location?

  # CONSTANTS
  enum :level, { Beginner: 0, Intermediate: 1, Advanced: 2 }
  ACTIVITY_TYPES =['American Rules Football', 'Archery', 'Australian Rules Football',
                  'Badminton (Doubles)', 'Bandy', 'Baseball', 'Basketball', 'Beach Volleyball',
                  'BMX Racing', 'Bodyboard', 'Bodybuilding', 'Bouldering', 'Boxing (Fitness/Training)',
                  'Brazilian Jiu-Jitsu (BJJ)', 'Capoeira', 'Camping', 'Canoe Polo', 'Canoeing',
                  'Cliff Diving (Cliff Jumping)', 'Caving (Spelunking)', 'Cricket', 'CrossFit', 'Cycle Cross',
                  'Cycling (Road)', 'Dance Fitness (Dance Aerobics)', 'Diving (Scuba Diving)', 'Fencing',
                  'Field Hockey', 'Fishing', 'Fitness Bootcamp', 'Floorball', 'Frisbee Golf', 'Football (Soccer)',
                  'Futsal', 'Gaelic Football', 'Golf', 'Handball', 'HIIT', 'Hiking', 'Ice Hockey', 'Ice Skating',
                  'Jet Skiing', 'Judo', 'Karate', 'Kettlebell Training', 'Kickboxing', 'Kung Fu', 'Krav Maga',
                  'Knee Boarding', 'Lacrosse', 'Marathon Running', 'Mixed Martial Arts (MMA)', 'Mountain Biking',
                  'Muay Thai', 'Mountaineering', 'Netball', 'Obstacle Course Racing', 'Pickleball', 'Pilates', 'Powerlifting',
                  'Rafting', 'Resistance Training (Strength Training)', 'Rock Climbing', 'Rowing', 'Running (Trail)',
                  'Sailing', 'Savate', 'Shootfighting', 'Skydiving', 'Snowboarding', 'Sledding', 'Snorkeling',
                  'Snowshoeing', 'Sport Fishing', 'Stand-Up Paddleboarding (SUP)', 'Stargazing', 'Surf Skating',
                  'Surfing', 'Synchronized Swimming', 'Taekwondo', 'Team Workout', 'Tennis', 'Tchoukball',
                  'Trail Running', 'Tabata Training', 'Touch Rugby', 'Triathlon', 'Wake Surfing', 'Wakeboarding',
                  'Water Polo', 'Weightlifting', 'Wing Chun', 'Wrestling', 'Zumba', 'Zip Lining', 'Windsurfing',
                  'Bungee Jumping']

  scope :search, ->(keyword) { where("title ILIKE ? OR description ILIKE ?", "%#{keyword}%", "%#{keyword}%") }
  scope :by_date, ->(date) { where(start: date.beginning_of_day..date.end_of_day) }
  scope :by_category, ->(category) { where(category: category) }
  scope :free_or_paid, ->(price_type) { where(price: price_type == 'free' ? 0 : 1..Float::INFINITY) }
  scope :sorted_by, ->(sort_by) { order(sort_by) }
  scope :near_location, ->(location) { near(location, 50) } # 50 km radius
end
