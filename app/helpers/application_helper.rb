module ApplicationHelper
  def time_since(time)
    time_elapsed = (Time.now - time).seconds.to_i
    if time_elapsed < 60
      time_unit = "seconds"
    elsif time_elapsed < 60*60
      time_unit = "minutes"
      time_elapsed = (time_elapsed/60).to_i
    elsif time_elapsed < 60*60*24
      time_unit = "hours"
      time_elapsed = (time_elapsed/(60*60)).to_i
    elsif time_elapsed < 60*60*24*7
      time_unit = "days"
      time_elapsed = (time_elapsed/(60*60*24)).to_i
    else
      time_unit = "weeks"
      time_elapsed = (time_elapsed/(60*60*24*7)).to_i
    end
    time_unit.chop! if time_elapsed == 1
    "#{time_elapsed} #{time_unit} ago"
  end

  def tag_link(tag)
    link_to tag.with_hash, root_path(
      params.merge({ tag: tag.name }).permit(:sort, :tag, :page)
    )
  end

  def user_link(user)
    user_is_followee = user_logged_in? && current_user.is_following?(user)
    link_to user.username, user_path(user),
      class: ("following" if user_is_followee)
  end
end
