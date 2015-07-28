class CommentPolicy < ApplicationPolicy
  def update?
    user and user == record.user
  end

  def destroy?
    user and user == record.user
  end
end
