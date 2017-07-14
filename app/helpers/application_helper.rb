module ApplicationHelper

  def present(object, klass = nil)
    klass ||= "#{object.class}Presenter".constantize
    presenter = klass.new(object, self)
    yield presenter if block_given?
    presenter
  end

  def user_link_class(user)
    if user.has_cached_role? :admin
      "admin"
    elsif user.has_cached_role? :moderator
      "moderator"
    elsif current_user.present? && current_user.is_following?(user)
      "following"
    else
      "regular"
    end
  end

  # https://stackoverflow.com/questions/3705898/best-way-to-add-current-class-to-nav-in-rails-3
  def nav_link(link_text, link_path)
    class_name = current_page?(link_path) ? 'btn_blue' : ''
    link_to link_text, link_path, class: class_name
  end
end
