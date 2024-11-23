class GroupCommentPolicy < ApplicationPolicy
  def create?
    user.present? # Any logged-in user can create a comment
  end

  def destroy?
    record.user == user # Only the user who created the comment can delete it
  end
end
