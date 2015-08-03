module PostsHelper
  def sortable(sort_option)
    is_sorted_by = params[:sort] == sort_option
    link_to sort_option, params.merge({ sort: sort_option }),
                         class: ("btn_blue" if is_sorted_by)
  end
end
