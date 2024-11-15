class Activity < ApplicationRecord
  belongs_to :user
  has_many :bookings, dependent: :destroy
  has_many :activity_comments, dependent: :destroy
  has_many :users, through: :bookings
  validates :title, :sport, :description, :location, :start, :duration, :price, presence: true

  geocoded_by :location
  after_validation :geocode, if: :will_save_change_to_location?
end
