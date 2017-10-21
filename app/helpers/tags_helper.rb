module TagsHelper
  def rel_tag_link(tag)
    link_to tag.name, params.permit(:sort).merge({ tag: tag.name }), class: 'tag'
  end

  def abs_tag_link(tag, with_hash: true)
    text, link_class = with_hash ? [tag.with_hash, ''] : [tag.name, 'tag']
    link_to text, root_path(tag: tag.name), class: link_class
  end

  def list_inline(tags)
    tags.map { |tag| abs_tag_link(tag, with_hash: false) }.join(" ").html_safe
  end

  def list_with_post_count(tags)
    content_tag :ul do
      tags.map { |tag|
        content_tag :li do
          abs_tag_link(tag, with_hash: false) + " x #{tag.posts_count}"
        end
      }.join.html_safe
    end
  end
end
