class PostPresenter < ContentPresenter
  presents :post
  delegate :title, :text, :url, to: :post

  def comments_count
    pluralize content.comments_count, 'comment'
  end

  def linked_title
    link_to post.title, post.text_only? ? post_path(post) : post.url
  end

  def linked_comments
    link_to comments_count, post_path(post)
  end

  def linked_tags(is_blurb)
    content_tag(:div, class: "post_tags") do
      post.tags.each do |tag|
        concat ' '
        concat (is_blurb ? abs_tag_link(tag) : rel_tag_link(tag))
      end
    end
  end

  def shares
    fa_icon 'paper-plane-o'
    content_tag :span, id: 'post_shares' do
      concat fa_icon 'paper-plane-o'
      concat ' x '
      concat post.shares_count
    end
  end

  def share_link
    return '' if user_signed_in? && current_user.shared_post?(post)

    link_to post_shares_path(post), remote: true, method: :post, class: "share_link" do
      fa_icon 'paper-plane-o'
    end
  end

  def edit_link
    link_to "edit", edit_post_path(post), class: "btn_blue"
  end

  def delete_link
    link_to "delete", post_path(post), class: "btn_yellow", method: :delete
  end

  def type
    post.text_only? ? "text" : "external link"
  end

  def badges
    badges_count = post.badges.count
    return unless badges_count > 0

    content_tag 'span', id: 'post_badges' do
      concat '| '
      concat fa_icon 'cogs'
      concat ' x '
      concat badges_count
    end
  end

  def badge_link
    return unless user_signed_in? && current_user.badges_to_give.exists?

    link_to post_badgings_path(post), method: :post, id: 'post_badge_link', class: 'badge_link' do
      fa_icon 'magic'
    end
  end
end
