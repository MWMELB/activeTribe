class ActivityCommentPolicy < ApplicationPolicy
  def create?
    user.present?
  end

  def destroy?
    user == record.user
  end
end
