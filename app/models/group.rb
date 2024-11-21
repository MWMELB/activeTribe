class Group < ApplicationRecord
  belongs_to :user
  has_many :group_users
  has_many :group_comments
  has_many :users, through: :group_users
  has_one_attached :photo
  validates :name, :description, presence: true
end
