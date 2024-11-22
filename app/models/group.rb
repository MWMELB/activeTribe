class Group < ApplicationRecord
  belongs_to :user
  has_many :group_users
  has_many :group_comments
  has_many :members, through: :group_users, source: :user
  has_one_attached :photo
  validates :name, :description, presence: true
end
