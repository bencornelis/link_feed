require "rails_helper"

describe "viewing the feed" do
  it "only displays posts shared by user followees" do
    followee = create(:user)
    non_followee = create(:user)

    current_user =
      create(:user) { |user|
        user.followees << followee }

    feed_post = create_post(title: "Title 1")
    non_feed_post = create_post(title: "Title 2")

    followee.shared_posts << feed_post
    non_followee.shared_posts << non_feed_post

    login_as(current_user)
    visit root_path
    click_on "feed"
    expect(page).to have_content "Title 1"
    expect(page).to have_no_content "Title 2"
  end
end

describe "sorting by recent" do
  it "displays feed posts ordered by time" do
    followee = create(:user)
    current_user =
      create(:user) { |user|
        user.followees << followee }

    # default is 10 posts per page
    (1..11).each do |n|
      Timecop.freeze((n+1).days.ago) do
        post = create_post(title: "Title #{n}")
        followee.shared_posts << post
      end
    end

    non_followee = create(:user)
    Timecop.freeze(1.day.ago) do
      post = create_post(title: "Non followee post")
      non_followee.shared_posts << post
    end

    login_as(current_user)
    visit feed_path
    click_on "recent"
    expect(page).to have_content "Title 1"
    expect(page).to have_no_content "Title 11"
    expect(page).to have_no_content "Non followee post"
  end
end

describe "viewing comments" do
  it "displays all comments by the user's followees" do
    followee = create(:user)
    non_followee = create(:user)

    current_user =
      create(:user) { |user|
        user.followees << followee }

    post = create_post

    feed_comment =
      create(:comment, text: "Great post!") do |comment|
        comment.user = followee
        post.comments << comment
      end

    non_feed_comment =
      create(:comment, text: "Terrible post!") do |comment|
        comment.user = non_followee
        post.comments << comment
      end

    login_as(current_user)
    visit feed_path
    click_on "comments"
    expect(page).to have_content "Great post!"
    expect(page).to have_no_content "Terrible post!"
  end
end
