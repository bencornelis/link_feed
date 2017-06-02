module ApplicationHelper

  def present(object, klass = nil)
    klass ||= "#{object.class}Presenter".constantize
    presenter = klass.new(object, self)
    yield presenter if block_given?
    presenter
  end

  def user_link_class(user)
    if user.has_role? :admin
      "admin"
    elsif user.has_role? :moderator
      "moderator"
    elsif policy(user).detect_followee?
      "following"
    else
      "regular"
    end
  end
end
