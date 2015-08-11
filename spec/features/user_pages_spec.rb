require "rails_helper"

describe "following a user" do
  it "lets a logged in user follow another user", js: true do
    user1 = FactoryGirl.create(:user)
    post = FactoryGirl.create(:post)
    user1.posts << post
    user2 = FactoryGirl.create(:user)
    login_as(user2)
    visit post_path(post)
    click_on user1.username
    click_on "follow #{user1.username}"
    expect(page).to have_no_content "follow #{user1.username}"
    expect(page).to have_content "Followers (1): #{user2.username}"
    click_on "Profile"
    expect(page).to have_content "Followees (1): #{user1.username}"
  end
end
