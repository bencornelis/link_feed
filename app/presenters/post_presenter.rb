class PostPresenter < BasePresenter
  presents :post
  delegates :user, to: :post

  def linked_title
    if post.text_only?
      h.link_to post.title, h.post_path(post)
    else
      h.link_to post.title, post.url
    end
  end

  def linked_username
    
  end

end
def user_link(user)
  user_is_followee = user_logged_in? && current_user.is_following?(user)
  link_to user.username, user_path(user),
    class: ("following" if user_is_followee)
end
