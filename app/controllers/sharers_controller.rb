class SharersController < ApplicationController
  include Polymorphic

  def index
    shareable = find_shareable
    @sharers = shareable.users_shared_by
  end

  private

  alias_method :find_shareable, :find_polymorphic_object
end