class UserPolicy < ApplicationPolicy
  def follow?
    user.present? &&
    other_user?   &&
    !user.is_following?(record)
  end

  private
  def other_user?
    user != record
  end
end
