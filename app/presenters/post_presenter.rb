class PostPresenter < ContentPresenter
  presents :post
  delegate :title, :text, to: :post

  def linked_title
    if post.text_only?
      link_to post.title, post_path(post)
    else
      link_to post.title, post.url
    end
  end

  def linked_comments
    link_to comments_count, post_path(post)
  end

  def linked_tags
    tag_link(post.first_tag) + " / " + tag_link(post.second_tag)
  end

  def followee_shares
    count = post.try(:followee_shares_count)
    if count
      text = "#{count} followee #{count == 1 ? 'share' : 'shares'}"
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