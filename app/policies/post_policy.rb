class PostPolicy < ApplicationPolicy
  policy_for :post

  def update?
    admin? || owner?
  end

  def destroy?
    admin?
  end

  def share?
    not owner? and not user.has_shared?(post)
  end

  require_present_user :update, :destroy, :share
end
