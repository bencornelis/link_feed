class UserPolicy < ApplicationPolicy
  policy_for :other_user

  def follow?
    user and user != other_user and not user.is_following?(other_user)
  end

  def detect_followee?
    user and user.is_following?(other_user)
  end
end
