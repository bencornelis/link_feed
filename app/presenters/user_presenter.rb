class UserPresenter < BasePresenter
  presents :user
  delegate :username, :shares_count, :followees, :followers,
  :followers_count, :followees_count, to: :user

  def avatar
    image_tag user.avatar.url(:thumb), class: "avatar"
  end

  def linked_username(other_user)
    link_to other_user.username, user_path(other_user),
      class: ("following" if policy(other_user).detect_followee?)
  end

  def followee_list
    names = followees.map { |followee| linked_username(followee) }.join(", ")
    "Followees (#{followees_count}): #{names}".html_safe
  end

  def follower_list
    names = followers.map { |follower| linked_username(follower) }.join(", ")
    "Followers (#{followers_count}): #{names}".html_safe
  end

  def follow_link
    link_to "follow #{username}", user_follows_path(user),
                                  remote: true, method: :post,
                                  class: "btn_yellow"
  end

  def shares
    "#{shares_count} #{shares_count == 1 ? 'share' : 'shares'}"
  end

end
