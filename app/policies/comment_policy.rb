class CommentPolicy < ApplicationPolicy
  def create?
    user != nil
  end

  def update?
    user and user == record.user
  end

  def destroy?
    user and user == record.user
  end
end
