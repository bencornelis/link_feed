class ContentPresenter < BasePresenter
  presents :content
  delegate :user, to: :content

  def comments_count
    "#{content.comments_count} #{content.comments_count == 1 ? 'comment' : 'comments'}"
  end

  def time_since_created
    "#{time_ago_in_words(content.created_at)} ago"
  end

  def time_since_edited
    " | edited #{time_ago_in_words(content.updated_at)} ago" if content.edited?
  end

  def linked_username
    link_to user.username, user_path(user),
      class: user_link_class(user)
  end
end
