class CommentPresenter < ContentPresenter
  presents :comment
  delegate :text, :post, :parent_id, to: :comment

  def formatted_text
    simple_format(text)
  end

  def linked_shares
    return unless comment.shares_count > 0

    content_tag :span, class: 'comment_shares' do
      concat '· '
      concat fa_icon 'paper-plane-o'
      concat link_to_modal " x #{comment.shares_count}",
                           comment_sharers_path(comment)
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
    anchor = parent_id ? "comment_#{parent_id}" : ""
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

  def badges
    badges_count = comment.badgings_count
    return unless badges_count > 0

    content_tag 'span', id: 'comment_badges' do
      concat ' ·'
      badges_count.times do
        concat image_tag 'badge.png', class: 'badge_icon'
      end
    end
  end

  def badge_link
    return unless user_signed_in? && current_user.badges_to_give.any?

    link_to comment_badgings_path(comment), method: :post, class: 'badge_link comment_badge_link' do
      fa_icon 'magic'
    end
  end
end
