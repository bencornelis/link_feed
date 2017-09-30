require "rails_helper"

describe "following a user" do
  it "lets a logged in user follow another user", js: true do
    follower = create :user
    followee = create :user

    login_as(follower)
    visit user_path(followee)

    expect(page).to have_content "follow"
    expect(page).not_to have_content "unfollow"
    expect(page).to have_content "Followers (0)"

    click_on "follow"

    expect(page).to have_content "unfollow"
    expect(page).to have_content "Followers (1): #{follower.username}"

    visit profile_path
    expect(page).to have_content "Following (1): #{followee.username}"
  end

  it "lets a user unfollow a user" do
    follow   = create :follow
    follower = follow.follower
    followee = follow.followee

    login_as(follower)
    visit user_path(followee)

    expect(page).to have_content "Followers (1): #{follower.username}"

    click_on "unfollow"

    expect(page).to have_content "Followers (0)"
    expect(page).to have_content "follow"
    expect(page).not_to have_content "unfollow"
  end
end
