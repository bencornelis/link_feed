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

  def post_type(post)
    post.text_only? ? "text" : "external link"
  end
end
