class Post < ActiveRecord::Base
  class Filter < Struct.new(:sort_by, :tag, :page)
    def initialize(attributes = {})
      members.each do |key|
        send "#{key}=", attributes[key]
      end
    end

    def posts
      @posts ||= base.filter.scope
    end

    protected

    def filter
      sort.filter_by_page.filter_by_tag
    end

    def scope
      @scope
    end

    def base
      @scope = Post.includes(:tags, :user)
      self
    end

    def sort
      case sort_by
      when "time"
        @scope = @scope.recent
      when "comments"
        @scope = @scope.most_comments
      when "shares"
        @scope = @scope.most_shares
      end
      self
    end

    def filter_by_page
      @scope = on_page
      self
    end

    def filter_by_tag
      @scope = with_tag if tag
      self
    end

    private

    def with_tag
      @scope.joins(:tags).where("tags.name = :tag", tag: tag)
    end

    def on_page
      @scope.paginate(page: page, per_page: 7)
    end
  end
end
