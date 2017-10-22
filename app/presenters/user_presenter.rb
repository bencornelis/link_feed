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
            class: "btn_yellow"
  end

  def unfollow_link
    link_to 'unfollow',
            user_follow_path(user, user.followee_follow(current_user)),
            remote: true,
            method: :delete,
            class: "btn_yellow"
  end

  def followers_icon
    content_tag 'span' do
      concat fa_icon 'users'
      concat ' x '
      concat followers_count
    end
  end

  def badges_received_icon
    badges_received_count = user.badgings_received.count

    content_tag 'span' do
      concat fa_icon 'cogs'
      concat ' x '
      concat badges_received_count
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
