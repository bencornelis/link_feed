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
    comment_count = post.comment_count
    link_text = "#{comment_count} comments"
    link_text.chop! if comment_count == 1
    link_to link_text, post_path(post)
  end

  def tag_links(post)
    capture do
      concat link_to post.first_tag_name, params.merge({ tag: post.first_tag_name[1..-1] })
      concat " / "
      concat link_to post.second_tag_name, params.merge({ tag: post.second_tag_name[1..-1] })
    end
  end

  def shares(post)
    share_count = post.share_count
    share_text = "#{share_count} shares"
    share_text.chop! if share_count == 1
    content_tag :span, share_text, class: "shares"
  end

  def share_link(post)
    link_to "+ share", post_shares_path(post),
                         remote: true, method: :post,
                         class: "share_link btn_yellow"
  end
end
