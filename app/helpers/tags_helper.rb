module TagsHelper
  def tag_link(tag)
    link_to tag.with_hash, params.permit(:tag,:page).merge({ tag: tag.name })
  end

  def ext_tag_link(tag)
    link_to tag.with_hash, root_path(tag: tag.name)
  end

  def list_inline(tags)
    tags.map { |tag| ext_tag_link(tag) }.join(" ").html_safe
  end

  def list_with_post_count(tags)
    content_tag :ul do
      tags.map { |tag|
        content_tag :li do
          ext_tag_link(tag) + ": #{tag.posts_count}"
        end
      }.join.html_safe
    end
  end
end
