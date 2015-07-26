module PostsHelper
  def post_link(post)
    if post.text_only?
      link_to post.title, post_path(post)
    else
      link_to post.title, post.url
    end
  end

  def comments_link(post)
    comment_count = post.comment_count
    link_text = "#{comment_count} comments"
    link_text.chop! if comment_count == 1
    link_to link_text, post_path(post)
  end

  def tag_links(post)
    capture do
      concat link_to post.first_tag_name, root_path
      concat " * "
      concat link_to post.second_tag_name, root_path
    end
  end
end
