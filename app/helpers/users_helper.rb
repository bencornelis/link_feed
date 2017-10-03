module UsersHelper
  def user_link_class(user)
    if user.has_cached_role? :admin
      "admin"
    elsif user.has_cached_role? :moderator
      "moderator"
    elsif current_user.present? && current_user.following?(user)
      "following"
    else
      "regular"
    end
  end
end
