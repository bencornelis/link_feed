module CommentsHelper

  def comment_li(comment, &block)
    content = capture(&block)
    if comment.commentable.class == Comment
      content_tag_for :li, comment, :class => 'nested_comment' do
        content
      end
    else
      content_tag_for :li, comment do
        content
      end
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
