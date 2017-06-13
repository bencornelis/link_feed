class PostPresenter < ContentPresenter
  presents :post
  delegate :title, :text, :url, to: :post

  def linked_title
    link_to post.title, post.text_only? ? post_path(post) : post.url
  end

  def linked_comments
    link_to comments_count, post_path(post)
  end

  def linked_tags
    tags = post.tags
    case tags.size
    when 1
      tag_link(tags.first)
    when 2
      tag_link(tags.first) + " / " + tag_link(tags.last)
    end
  end

  def followee_shares
    count = post.try(:followee_shares_count)
    if count
      text = "#{count} followed #{count == 1 ? 'share' : 'shares'}"
      h.capture do
        concat " / "
        concat content_tag :span, text, class: "followee_shares"
      end
    end
  end

  def shares
    text = "#{post.shares_count} #{post.shares_count == 1 ? 'share' : 'shares'}"
    content_tag :span, text, class: "shares"
  end

  def share_link
    content_tag :span, class: "share_link" do
      concat "| "
      concat link_to "+ share", post_shares_path(post),
                                remote: true, method: :post,
                                class: "btn_yellow"
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
end
