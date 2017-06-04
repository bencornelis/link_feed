class Post < ActiveRecord::Base
  class Global < Struct.new(:filter)

    def posts
      @posts ||= filter.apply_to(base.scope).select_posts
    end

    protected

    def scope
      @scope
    end

    def base
      @scope = Post.includes(:user)
      self
    end
  end
end
