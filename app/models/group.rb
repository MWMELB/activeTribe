class Group < ApplicationRecord
  belongs_to :user
  has_many :group_users, :group_comments
  has_many :users, through: :group_users
  validates :name, :description, presence: true
end
