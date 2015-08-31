module PostsHelper
  def sortable(sort_by)
    is_sorted_by = params[:sort_by] == sort_by
    link_to sort_by, params.merge({ sort_by: sort_by }),
                         class: ("btn_blue" if is_sorted_by)
  end
end
