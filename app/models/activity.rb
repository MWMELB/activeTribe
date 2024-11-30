class Activity < ApplicationRecord
  belongs_to :user
  has_many :bookings, dependent: :destroy
  has_many :activity_comments, dependent: :destroy
  has_many :bookers, through: :bookings, source: :user
  has_one_attached :photo
  validates :title, :category, :description, :location, :start, :duration, :price, :capacity, :level, presence: true
  enum :level, { Beginner: 0, Intermediate: 1, Advanced: 2 }
  geocoded_by :location
  after_validation :geocode, if: :will_save_change_to_location?

  scope :search, ->(keyword) { where("title ILIKE ? OR description ILIKE ?", "%#{keyword}%", "%#{keyword}%") }
  scope :by_date, ->(date) { where(start: date.beginning_of_day..date.end_of_day) }
  scope :by_category, ->(category) { where(category: category) }
  scope :free_or_paid, ->(price_type) { where(price: price_type == 'free' ? 0 : 1..Float::INFINITY) }
  scope :sorted_by, ->(sort_by) { order(sort_by) }
  scope :near_location, ->(location) { near(location, 50) } # 50 km radius
end
