class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  before_validation :generate_username, on: :create

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :activities, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many :groups, dependent: :destroy
  has_many :group_users, dependent: :destroy
  has_many :group_posts, dependent: :destroy
  has_many :group_comments, dependent: :destroy
  has_many :activity_comments, dependent: :destroy
  has_many :groups, through: :group_users
  has_many :activities, through: :bookings
  has_many :booked_activities, through: :bookings, source: :activity

  validates :first_name, :last_name, :birth_date, :email, presence: true
  has_one_attached :photo

  # Attribute for terms agreement (sign-up page)
  attr_accessor :terms

  validate :terms_accepted

  private

  def terms_accepted
    errors.add(:base, "Terms must be accepted") unless ActiveRecord::Type::Boolean.new.cast(terms)
  end

  def name
    "#{first_name} #{last_name}"
  end

  def generate_username
    self.username = "#{first_name.downcase}_#{last_name.downcase}"
  end
end
