class Post < ActiveRecord::Base
  class Global < Filter
    def base
      Post.preload(:tags, {:user => :roles})
    end
  end
end
