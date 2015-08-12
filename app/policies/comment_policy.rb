class CommentPolicy < ApplicationPolicy
  policy_for :comment

  def create?
    user != nil
  end

  def update?
    user and user == comment.user
  end

  def destroy?
    user and user == comment.user
  end
end
