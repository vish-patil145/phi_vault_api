# app/policies/consent_policy.rb
class ConsentPolicy < ApplicationPolicy
  # Only admin or doctor can manage consents
  def index?
    user.admin? || user.doctor?
  end

  def create?
    user.admin? || user.doctor?
  end

  def show?
    user.admin? || user.doctor?
  end

  def update?
    user.admin? || user.doctor?
  end

  def destroy?
    user.admin?
  end
end
