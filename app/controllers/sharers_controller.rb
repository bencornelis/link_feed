class SharersController < ApplicationController
  def index
    shareable = find_shareable
    @sharers = shareable.users_shared_by
  end

  private

  def find_shareable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
  end
end