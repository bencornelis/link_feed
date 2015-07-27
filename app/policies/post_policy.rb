class PostPolicy < ApplicationPolicy
  def share?
    user and not user.has_shared?(record)
  end
end
