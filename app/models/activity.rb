class Activity < ApplicationRecord
  belongs_to :user
  has_many :bookings, dependent: :destroy
  has_many :activity_comments, dependent: :destroy
  has_many :bookers, through: :bookings, source: :user
  has_one_attached :photo
  validates :title, :category, :description, :location, :start, :duration, :price, :capacity, presence: true

  geocoded_by :location
  after_validation :geocode, if: :will_save_change_to_location?
end
