class ActivityPostPolicy < ApplicationPolicy
  def post_owner?
    record.user == user
  end

  def activity_member?
    record.activity.bookers.include?(user) || record.activity.user == user
  end

  def show?
    user.present?
    #  && (post_owner? || group_member?)
  end

  def create?
    user.present? && (post_owner? || activity_member?) # Any logged-in user can create a post
  end

  def destroy?
    post_owner? # Only the user who created the post can delete it
  end
end
