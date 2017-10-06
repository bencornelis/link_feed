class PostPolicy < ApplicationPolicy
  def edit?
    user.present? && admin_or_owner?
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end

  private
  def admin_or_owner?
    admin? || owner?
  end

  def owner?
    user == record.user
  end

  def admin?
    user.has_cached_role? :admin
  end
end
