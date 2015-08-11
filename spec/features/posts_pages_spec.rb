require "rails_helper"

describe "adding a post" do
  it "displays post information for a post just added" do
    user = FactoryGirl.create(:user)
    login_as(user)
    visit root_path
    click_on "new_post_link"
    fill_in "post_title", with: "What is the best games soundtrack?"
    fill_in "post_text", with: "I really want to know!"
    fill_in "post_tag1_name", with: "games"
    fill_in "post_tag2_name", with: "soundtracks"
    click_on "submit"
    expect(page).to have_content "What is the best games soundtrack?"
    expect(page).to have_content "#games"
    expect(page).to have_content "#soundtracks"
    expect(page).to have_no_content "I really want to know!"
  end

  it "requires a user to be logged in" do
    user = FactoryGirl.create(:user)
    visit root_path
    click_on "new_post_link"
    expect(page).to have_content "You must be logged in to do that."
  end
end

describe "sharing a post" do
  it "requires the user to be logged in" do
    post = create_post
    visit post_path(post)
    expect(page).to have_content post.title
    expect(page).to have_no_content "+ share"
  end

  it "only lets the user share a post once", js: true do
    post = create_post
    user = FactoryGirl.create(:user)
    login_as(user)
    visit post_path(post)
    click_on "+ share"
    expect(page).to have_no_content "+ share"
    click_on "Profile"
    expect(page).to have_content post.title
  end
end

describe "editing a post" do
  it "does not let regular users edit another's post" do
    post = create_post
    user = FactoryGirl.create(:user)
    login_as(user)
    visit post_path(post)
    expect(page).to have_no_content "edit"
  end

  it "lets a user edit their own post" do
    post = create_post
    login_as(post.user)
    visit post_path(post)
    click_on "edit"
    fill_in "title", with: "a new title"
    click_on "submit edit"
    expect(page).to have_no_content "submit edit"
    expect(page).to have_content "a new title"
  end
end
