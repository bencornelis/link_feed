require "rails_helper"

describe "following a user" do
  it "lets a logged in user follow another user", js: true do
    follower = create :user
    followee = create :user

    login_as(follower)
    visit user_path(followee)

    expect(page).to have_content "follow"
    expect(page).not_to have_content "unfollow"
    within ".followers" do
      expect(page).to have_content "0"
    end

    click_on "follow"

    expect(page).to have_content "unfollow"
    within '.followers' do
      expect(page).to have_content "1"
    end

    visit profile_path

    within ".followees" do
      expect(page).to have_content "following: 1"
    end
  end

  it "lets a user unfollow a user", js: true do
    follow   = create :follow
    follower = follow.follower
    followee = follow.followee

    login_as(follower)
    visit user_path(followee)

    within ".followers" do
      expect(page).to have_content "1"
    end

    click_on "unfollow"

    within ".followers" do
      expect(page).to have_content "0"
    end
    expect(page).to have_content "follow"
    expect(page).not_to have_content "unfollow"
  end
end

describe "an unauthorized action" do
  it "redirects the user to the root path and displays a message" do
    login_as(create(:user))

    visit edit_post_path(create(:post))

    expect(page).to have_current_path root_path
    expect(page).to have_content "You are not authorized to perform this action."
  end
end

describe "giving and receiving badges", js: true do
  it "assigns a user a badge to give for every 10 shares they receive" do
    user = create :user, shares_received_since_last_badge: 9
    post = create :post, user: user

    visit user_path(user)

    within '.badges_given' do
      expect(page).to have_content '0 of 0'
    end

    # the user has 9 shares, now manually give a 10th
    login_as(create(:user))
    visit post_path(post)
    find('.share_link').click

    visit user_path(user)

    within '.badges_given' do
      expect(page).to have_content '0 of 1'
    end
  end

  it "shows a user when one of their posts or comments has received a badge" do
    user = create :user
    post = create :post, user: user
    comment = create :comment, user: user

    visit user_path(user)
    within '.badges_received' do
      expect(page).to have_content '0'
    end

    login_as(create(:user_with_badges))
    visit post_path(post)

    find('#post_main').hover
    find('#post_badge_link').click

    visit user_path(user)
    within '.badges_received' do
      expect(page).to have_content '1'
    end
  end
end
