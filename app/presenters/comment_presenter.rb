class CommentPresenter < ContentPresenter
  presents :comment
  delegate :text, :post, :nested?, to: :comment

  def formatted_text
    simple_format(text)
  end

  def reply_link
    link_to "reply", new_comment_comment_path(comment), remote: true
  end

  def parent_link
    if nested?
      link_to "parent", "#comment_#{comment.commentable_id}"
    end
  end

  def distant_parent_link
    link_to "parent", post_path(post) + "#comment_#{comment.commentable_id}"
  end

  def edit_link
    link_to "edit", edit_comment_path(comment), class: "btn_blue", remote: true
  end

  def delete_link
    link_to "delete", comment_path(comment), class: "btn_yellow", method: :delete
  end

  def post_link(link_name)
    link_to link_name, post_path(post)
  end
end
