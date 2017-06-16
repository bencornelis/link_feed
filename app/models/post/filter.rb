class Post < ActiveRecord::Base
  class Filter < Struct.new(:sort_by, :tag, :page, :user)
    def initialize(attributes = {})
      members.each do |key|
        send "#{key}=", attributes[key]
      end
    end

    def posts
      @posts ||= filter_by_tag.sort.filter_by_page.scope
    end

    protected

    def scope
      @scope ||= base
    end

    def base
      Post.all
    end

    def sort
      case sort_by
      when "time"
        @scope = scope.recent
      when "comments"
        @scope = scope.most_comments
      when "shares"
        @scope = scope.most_shares
      end
      self
    end

    def filter_by_page
      @scope = scope.paginate(page: page, per_page: 10)
      self
    end

    def filter_by_tag
      @scope = scope.joins(:tags).where(tags: {name: tag}) if tag
      self
    end
  end
end
