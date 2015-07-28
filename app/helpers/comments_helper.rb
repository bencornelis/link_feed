module CommentsHelper

  def comment_li(comment, &block)
    content = capture(&block)
    if comment.commentable.class == Comment
      content_tag_for :li, comment, :class => 'nested-comment' do
        content
      end
    else
      content_tag_for :li, comment do
        content
      end
    end
  end
end
