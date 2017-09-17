class UserPolicy < ApplicationPolicy
  def follow?
    user.present? &&
    other_user?   &&
    !user.following?(record)
  end

  private
  def other_user?
    user != record
  end
end
