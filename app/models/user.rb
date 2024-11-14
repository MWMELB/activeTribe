class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :activities, :bookings, :groups, :group_comments, :activity_comments
  belongs_to :groups, through: :group_users
  belongs_to :activities, through: :bookings
  validates :first_name, :last_name, :birth_date, presence: true
end
