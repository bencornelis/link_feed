module TagsHelper
  def list_inline(tags)
    tags.map { |tag| tag_link(tag) }.join(" ").html_safe
  end

  def list_with_post_count(tags)
    content_tag :ul do
      tags.each do |tag|
        content_tag :li do
          concat tag_link(tag)
          concat ": "
          concat tag.posts_count
        end
      end
    end
  end
end
