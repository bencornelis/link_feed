class CommentPolicy < ApplicationPolicy
  policy_for :comment

  def update?
    admin? || moderator? || owner?
  end

  def destroy?
    admin? || moderator? || owner?
  end

  require_present_user :create, :update, :destroy
end
