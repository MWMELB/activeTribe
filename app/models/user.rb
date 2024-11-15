class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :activities
  has_many :bookings
  has_many :groups
  has_many :group_comments
  has_many :activity_comments
  has_many :groups, through: :group_users
  has_many :activities, through: :bookings
  validates :first_name, :last_name, :birth_date, presence: true
end
