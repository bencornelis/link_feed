module TagsHelper
  def list_inline(tags)
    tags.map { |tag| tag_link(tag) }.join(" ").html_safe
  end

  def tag_link(tag)
    link_to tag.with_hash, root_path(
      params.merge({ tag: tag.name }).permit(:sort, :tag, :page)
    )
  end

  def list_with_post_count(tags)
    content_tag :ul do
      tags.map { |tag|
        content_tag :li do
          tag_link(tag) + ": #{tag.posts_count}"
        end
      }.join.html_safe
    end
  end
end
