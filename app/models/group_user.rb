class GroupUser < ApplicationRecord
  belongs_to :user
  belongs_to :group
  validates :user, uniqueness: { scope: :group, message: "should only book activity once" }
end
