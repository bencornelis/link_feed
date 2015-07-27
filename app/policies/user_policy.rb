class UserPolicy < ApplicationPolicy
  def follow?
    user and user != record and not user.is_following?(record)
  end
end
