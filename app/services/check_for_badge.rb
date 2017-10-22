class CheckForBadge
  attr_reader :user
  def initialize(user)
    @user = user
  end

  def call
    user.shares_received_since_last_badge += 1
    return unless user.shares_received_since_last_badge == 10

    user.badges.create
    user.shares_received_since_last_badge = 0
    user.save
  end
end