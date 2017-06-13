class Tagging < ActiveRecord::Base
  belongs_to :post
  belongs_to :tag, :counter_cache => :posts_count

  accepts_nested_attributes_for :tag, reject_if: :all_blank
end
