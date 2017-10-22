class UserPresenter < BasePresenter
  presents :user
  delegate :username, :shares_count, :followees, :followers,
  :followers_count, :followees_count, to: :user

  def avatar
    image_tag MonsterId.generate(user.id).to_data_uri, class: "avatar"
  end

  def linked_username(other_user)
    link_to other_user.username,
            user_path(other_user),
            class: user_link_class(other_user)
  end

  def followee_list
    names = followees.map { |followee| linked_username(followee) }.join(", ")
    "Following (#{followees_count}): #{names}".html_safe
  end

  def follower_list
    names = followers.map { |follower| linked_username(follower) }.join(", ")
    "Followers (#{followers_count}): #{names}".html_safe
  end

  def follow_link
    link_to 'follow',
            user_follows_path(user),
            remote: true,
            method: :post,
            class: "btn_blue follow_link"
  end

  def unfollow_link
    link_to 'unfollow',
            user_follow_path(user, user.followee_follow(current_user)),
            remote: true,
            method: :delete,
            class: "btn_blue follow_link"
  end

  def followers_icon
    follower_icon_count_link = link_to_modal " x #{followers_count}",
                                             user_followers_path(user),
                                             class: 'follower_icon_count'

    content_tag 'span', class: 'follower_icon_container' do
      concat image_tag 'follower.png', class: 'follower_icon'
      concat follower_icon_count_link
    end
  end

  def badges_received_icon
    badges_received_count = user.badgings_received.count
    badge_icon_count_span = content_tag 'span', class: 'badge_icon_count' do
      concat ' x '
      concat badges_received_count
    end

    content_tag 'span', class: 'badge_icon_container' do
      concat image_tag 'badge.png', class: 'badge_icon'
      concat badge_icon_count_span
    end
  end

  def badges_given
    total_badges_count = user.badges.count
    badges_given_count = user.badges_given.count

    "#{badges_given_count} of #{total_badges_count}"
  end

  def days_a_member
    time_ago_in_words(user.created_at)
  end

  def shares_received
    user.shares_received.count
  end
end
