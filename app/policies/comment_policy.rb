class CommentPolicy < ApplicationPolicy
  def edit?
    user.present? && admin_mod_or_owner?
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end

  private
  def admin_mod_or_owner?
    admin? || moderator? || owner?
  end

  def owner?
    user == record.user
  end

  def admin?
    user.has_cached_role? :admin
  end

  def moderator?
    user.has_cached_role? :moderator
  end
end
