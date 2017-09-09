require "rails_helper"

describe "viewing the post feed" do
  it "only displays posts shared by user followees" do
    followee     = create :user
    non_followee = create :user

    user = create :user
    user.followees << followee

    feed_post     = create :post, title: "Title 1"
    non_feed_post = create :post, title: "Title 2"

    followee.shared_posts     << feed_post
    non_followee.shared_posts << non_feed_post

    login_as(user)
    visit root_path

    click_on "feed"

    expect(page).to have_content    "Title 1"
    expect(page).to have_no_content "Title 2"
  end
end

describe "sorting posts by recent" do
  it "displays feed posts ordered by time" do
    followee     = create :user
    non_followee = create :user

    user = create :user
    user.followees << followee

    # default is 10 posts per page
    (1..11).each do |n|
      Timecop.freeze((n+1).days.ago) do
        followee.shared_posts << create(:post, title: "Title #{n}")
      end
    end

    Timecop.freeze(1.day.ago) do
      non_followee.shared_posts << create(:post, title: "Non followee post")
    end

    login_as(user)
    visit posts_feed_path

    click_on "recent"

    expect(page).to have_content    "Title 1"
    expect(page).to have_no_content "Title 11"
    expect(page).to have_no_content "Non followee post"
  end
end

describe "viewing comments" do
  it "displays all comments by the user's followees" do
    followee     = create :user
    non_followee = create :user

    user = create :user
    user.followees << followee

    create :comment, text: "Great post!", user: followee
    create :comment, text: "Terrible post!", user: non_followee

    login_as(user)
    visit posts_feed_path

    click_on "comments"

    expect(page).to have_content    "Great post!"
    expect(page).to have_no_content "Terrible post!"
  end
end
