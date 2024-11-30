class GroupComment < ApplicationRecord
  belongs_to :user
  belongs_to :group_post
  validates :content, presence: true
end
