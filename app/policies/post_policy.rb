class PostPolicy < ApplicationPolicy
  def update?
    user and user == record.user
  end

  def destroy?
    user and user == record.user
  end

  def share?
    user and user != record.user and not user.has_shared?(record)
  end
end
