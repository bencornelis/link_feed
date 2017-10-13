class CommentPresenter < ContentPresenter
  presents :comment
  delegate :text, :post, :parent_id, to: :comment

  def formatted_text
    simple_format(text)
  end

  def shares
    return unless comment.shares_count > 0
    content_tag :span, class: 'comment_shares' do
      concat '| '
      concat fa_icon 'paper-plane-o'
      concat ' x '
      concat comment.shares_count
    end
  end

  def share_link
    return '' if user_signed_in? && current_user.shared_comment?(comment)

    link_to comment_shares_path(comment), remote: true, method: :post, class: 'share_comment_link' do
      fa_icon 'paper-plane-o'
    end
  end

  def reply_link
    link_to "reply",
            new_post_comment_path(post, parent_id: comment),
            remote: true
  end

  def parent_link
    return unless parent_id
    link_to "parent", "#comment_#{parent_id}", data: { turbolinks: 'false' }
  end

  def distant_parent_link
    anchor = parent_id ? "comment_#{parent_id}" : "post_main"
    link_to "parent", post_path(post, anchor: anchor)
  end

  def edit_link
    link_to "edit",
            edit_post_comment_path(post, comment),
            class: "btn_blue",
            remote: true
  end

  def delete_link
    link_to "delete",
            post_comment_path(post, comment),
            class: "btn_yellow",
            method: :delete
  end

  def post_link(link_name)
    link_to link_name, post_path(post)
  end
end
