class SharesController < ApplicationController
  include Polymorphic
  before_filter :authenticate_user!

  def create
    @shareable = find_shareable
    @shareable.shares.create(user_id: current_user.id,
                             share_receiver_id: @shareable.user_id)
    check_if_badge_should_be_awarded(@shareable.user)
    
    respond_to do |format|
      format.js { render "create_#{@shareable.class.to_s.downcase}_share" }
    end
  end

  private

  alias_method :find_shareable, :find_polymorphic_object

  def check_if_badge_should_be_awarded(user)
    if user.shares_received_count % 10 == 0
      user.badges.create
    end
  end
end
