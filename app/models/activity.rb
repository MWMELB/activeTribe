class Activity < ApplicationRecord
  belongs_to :user
  has_many :bookings
  has_many :activity_comments
  has_many :users, through: :bookings
  validates :title, :type, :description, :location, :start, :duration, :price, presence: true
end
