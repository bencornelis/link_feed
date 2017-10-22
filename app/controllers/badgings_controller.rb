class BadgingsController < ApplicationController
  def create
    @badgeable = find_badgeable
    badge = current_user.badges_to_give.first
    @badgeable.badgings.create(badge_id: badge.id,
                               badge_receiver_id: @badgeable.user_id)
    badge.update!(given: true)

    redirect_to :back, notice: notice_for(@badgeable)
  end

  private

  def find_badgeable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
  end

  def notice_for(badgeable)
    badgeable_type = badgeable.class.to_s.downcase
    "Thanks for badging that #{badgeable_type}!"
  end
end