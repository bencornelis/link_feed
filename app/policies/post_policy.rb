class PostPolicy < ApplicationPolicy
  policy_for :post

  def update?
    user and user == post.user
  end

  def destroy?
    user and user == post.user
  end

  def share?
    user and user != post.user and not user.has_shared?(post)
  end
end
