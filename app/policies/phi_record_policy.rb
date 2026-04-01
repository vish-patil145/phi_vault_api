# app/policies/phi_record_policy.rb
class PhiRecordPolicy < ApplicationPolicy
  def index?
    user.admin? || user.doctor?
  end

  def create?
    user.admin? || user.doctor?
  end

  def show?
    user.admin? || user.doctor?
  end
end
