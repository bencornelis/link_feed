module PostsHelper
def sortable(sort_option)
    is_sorted_by = params[:sort] == sort_option
    link_to sort_option, params.merge({ sort: sort_option }),
                         class: ("btn_blue" if is_sorted_by)
  end

  def post_link(post)
    if post.text_only?
      link_to post.title, post_path(post)
    else
      link_to post.title, post.url
    end
  end

  def comments_link(post)
    comment_count = post.comments_count
    link_text = "#{comment_count} #{comment_count == 1 ? 'comment' : 'comments'}"
    link_to link_text, post_path(post)
  end

  def post_tag_links(post)
    capture do
      concat tag_link(post.first_tag)
      concat " / "
      concat tag_link(post.second_tag)
    end
  end

  def followee_shares(post)
    count = post.try(:followee_shares_count)
    if count
      text = "#{count} followee #{count == 1 ? 'share' : 'shares'}"
      capture do
        concat " / "
        concat content_tag :span, text, class: "followee_shares"
      end
    end
  end

  def shares(post)
    share_count = post.shares_count
    share_text = "#{share_count} #{share_count == 1 ? 'share' : 'shares'}"
    content_tag :span, share_text, class: "shares"
  end

  def share_link(post)
    if policy(post).share?
      content_tag :span, class: "share_link" do
        concat "| "
        concat link_to "+ share", post_shares_path(post),
                                  remote: true, method: :post,
                                  class: "btn_yellow"
      end
    end
  end
end
