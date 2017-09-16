require "rails_helper"

describe "following a user" do
  it "lets a logged in user follow another user", js: true do
    follower = create :user
    followee = create :user

    login_as(follower)
    visit user_path(followee)

    expect(page).to have_content "follow #{followee.username}"
    expect(page).to have_content "Followers (0)"

    click_on "follow #{followee.username}"

    expect(page).to have_no_content "follow #{followee.username}"
    expect(page).to have_content    "Followers (1): #{follower.username}"

    visit profile_path
    expect(page).to have_content "Following (1): #{followee.username}"
  end
end
