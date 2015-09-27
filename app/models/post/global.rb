class Post < ActiveRecord::Base
  class Global < Struct.new(:filter)

    def posts
      @posts ||= filter.for(base.scope).select_posts
    end

    protected

    def scope
      @scope
    end

    def base
      @scope = Post.includes(:tags, :user)
      self
    end
  end
end
