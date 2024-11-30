class GroupPost < ApplicationRecord
  belongs_to :group
  belongs_to :user
  has_many :group_comments
  validates :content, presence: true
end
