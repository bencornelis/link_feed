module CommentsHelper

  def comment_li(comment, display_nesting = true, &block)
    content = capture(&block)
    is_nested = comment.commentable.class == Comment && display_nesting
    content_tag_for :li, comment, class: ("nested_comment" if is_nested) do
      content
    end
  end

  def link_to_parent(comment)
    if comment.commentable.class == Comment
      capture do
        concat "| "
        concat link_to "parent", "#comment_#{comment.commentable.id}"
      end
    end
  end
end
