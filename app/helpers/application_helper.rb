module ApplicationHelper

  def present(object, klass = nil)
    klass ||= "#{object.class}Presenter".constantize
    presenter = klass.new(object, self)
    yield presenter if block_given?
    presenter
  end

  def tag_link(tag)
    link_to tag.with_hash, root_path(
      params.merge({ tag: tag.name }).permit(:sort, :tag, :page)
    )
  end

  def user_link(user)
    user_is_followee = user_logged_in? && current_user.is_following?(user)
    link_to user.username, user_path(user),
      class: ("following" if user_is_followee)
  end

  def user_link_class(user)
    if user.has_role? :admin
      "admin"
    elsif user.has_role? :moderator
      "moderator"
    elsif policy(user).detect_followee?
      "following"
    end
  end
end
