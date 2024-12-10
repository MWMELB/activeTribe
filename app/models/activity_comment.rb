class ActivityComment < ApplicationRecord
  belongs_to :user
  belongs_to :activity_post
  validates :content, presence: true
end
