class UserPolicy < ApplicationPolicy
  def follow?
    user and not user.is_following?(record)
  end
end
