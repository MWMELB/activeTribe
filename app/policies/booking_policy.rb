class BookingPolicy < ApplicationPolicy
  # NOTE: Up to Pundit v2.3.1, the inheritance was declared as
  # `Scope < Scope` rather than `Scope < ApplicationPolicy::Scope`.
  # In most cases the behavior will be identical, but if updating existing
  # code, beware of possible changes to the ancestors:
  # https://gist.github.com/Burgestrand/4b4bc22f31c8a95c425fc0e30d7ef1f5

  def owner?
    record.activity.user == user
  end

  def create?
    record.activity.bookings.count < record.activity.capacity
  end

  def destroy?
    record.user == user
  end

  def empty?
    true
  end

  def accept?
    owner?
  end

  def decline?
    owner?
  end

  def booking_requests?
    user.present?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(user: user)
    end
  end
end
