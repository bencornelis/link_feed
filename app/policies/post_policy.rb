class PostPolicy < ApplicationPolicy
  policy_for :post

  def update?
    user.present? && (admin? || user == post.user)
  end

  def destroy?
    user.present? && admin?
  end

  def share?
    user.present? && user != post.user and not user.has_shared?(post)
  end
end
