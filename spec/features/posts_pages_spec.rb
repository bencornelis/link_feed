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
