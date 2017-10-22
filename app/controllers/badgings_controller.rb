class BadgingsController < ApplicationController
  include Polymorphic

  def create
    @badgeable = find_badgeable
    badge = current_user.badges_to_give.first
    @badgeable.badgings.create(badge_id: badge.id,
                               badge_receiver_id: @badgeable.user_id)
    badge.update!(given: true)

    redirect_to :back, notice: notice_for(@badgeable)
  end

  private

  alias_method :find_badgeable, :find_polymorphic_object

  def notice_for(badgeable)
    badgeable_type = badgeable.class.to_s.downcase
    "Thanks for badging that #{badgeable_type}!"
  end
end