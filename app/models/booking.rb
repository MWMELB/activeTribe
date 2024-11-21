class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :activity
  enum :status, { Pending: 0, Accepted: 1, Declined: 2 }
  validates :user, uniqueness: { scope: :activity, message: "should only book activity once" }
end
