class CommentPresenter < ContentPresenter
  presents :comment
  delegate :text, :post, :parent_id, to: :comment

  def formatted_text
    simple_format(text)
  end

  def reply_link
    link_to "reply", new_post_comment_path(post, parent_id: comment), remote: true
  end

  def parent_link
    if parent_id
      link_to "parent", "#comment_#{parent_id}"
    end
  end

  def distant_parent_link
    link_to "parent", post_path(post) + "#comment_#{comment.parent_id}"
  end

  def edit_link
    link_to "edit", edit_post_comment_path(post, comment), class: "btn_blue", remote: true
  end

  def delete_link
    link_to "delete", post_comment_path(post, comment), class: "btn_yellow", method: :delete
  end

  def post_link(link_name)
    link_to link_name, post_path(post)
  end
end
