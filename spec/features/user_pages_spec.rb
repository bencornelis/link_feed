require "rails_helper"

describe "following a user" do
  it "lets a logged in user follow another user", js: true do
    post = create :post
    user = create :user

    login_as(user)
    visit post_path(post)

    click_on post.username
    click_on "follow #{post.username}"

    expect(page).to have_no_content "follow #{post.username}"
    expect(page).to have_content    "Followers (1): #{user.username}"

    visit profile_path

    expect(page).to have_content "Following (1): #{post.username}"
  end
end
