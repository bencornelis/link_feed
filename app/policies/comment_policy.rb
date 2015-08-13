class CommentPolicy < ApplicationPolicy
  policy_for :comment
  permit_admin_to :update, :destroy
  permit_moderator_to :update, :destroy
  permit_owner_to :update, :destroy

  def create?
    user.present?
  end

  def update?
    user.present? && can_moderate?
  end

  def destroy?
    user.present? && can_moderate?
  end
end
