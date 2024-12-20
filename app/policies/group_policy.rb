class GroupPolicy < ApplicationPolicy
  # NOTE: Up to Pundit v2.3.1, the inheritance was declared as
  # `Scope < Scope` rather than `Scope < ApplicationPolicy::Scope`.
  # In most cases the behavior will be identical, but if updating existing
  # code, beware of possible changes to the ancestors:
  # https://gist.github.com/Burgestrand/4b4bc22f31c8a95c425fc0e30d7ef1f5

  def owner?
    record.user == user
  end

  def show?
    user.present?
  end

  def new?
    user.present?
  end

  def create?
    new?
  end

  def destroy?
    record.user == user
  end

  def post?
    user.present? && (record.members.include?(user) || owner?)
  end

  def comment?
    post?
  end

  class Scope < ApplicationPolicy::Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end
end
