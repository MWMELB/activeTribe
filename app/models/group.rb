class Group < ApplicationRecord
  belongs_to :user
  has_many :group_users
  has_many :group_posts
  has_many :members, through: :group_users, source: :user
  has_one_attached :photo
  validates :name, :description, presence: true

  include PgSearch::Model
  pg_search_scope :search_by_name_and_description,
    against: [ :name, :description ],
    using: {
      tsearch: { prefix: true }
    }
end
