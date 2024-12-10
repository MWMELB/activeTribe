class ActivityPost < ApplicationRecord
  belongs_to :user
  belongs_to :activity
  has_many :activity_comments
  validates :content, presence: true
end
