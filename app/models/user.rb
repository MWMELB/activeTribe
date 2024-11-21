class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :activities, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many :groups, dependent: :destroy
  has_many :group_users, dependent: :destroy
  has_many :group_comments, dependent: :destroy
  has_many :activity_comments, dependent: :destroy
  has_many :groups, through: :group_users

  has_many :activities, through: :bookings
  validates :first_name, :last_name, :birth_date, :email, presence: true

  # Attribute for terms agreement (sign-up page)
  attr_accessor :terms

  validate :terms_accepted

  private

  def terms_accepted
    errors.add(:terms, "must be accepted") unless terms == "1"
  end

  has_many :booked_activities, through: :bookings, source: :activity
  validates :first_name, :last_name, :birth_date, presence: true

end
