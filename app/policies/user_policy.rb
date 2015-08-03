class UserPolicy < ApplicationPolicy
  def follow?
    user and user != record and not user.is_following?(record)
  end

  def detect_followee?
    user and user.is_following?(record)
  end
end
