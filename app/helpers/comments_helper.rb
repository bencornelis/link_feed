module CommentsHelper
  def nested_comments(comments, parent: nil)
    comments.map do |comment, sub_comments|
      render(comment) +
      content_tag(:ul,
                  nested_comments(sub_comments, parent: comment),
                  class: "comments nested")
    end.join.html_safe
  end
end
