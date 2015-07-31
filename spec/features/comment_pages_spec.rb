require "rails_helper"

describe "adding a top level comment to a post", js: true do
  it "puts the new comment at the top" do
    poster = FactoryGirl.create(:poster)
    post = FactoryGirl.create(:post)
    poster.posts << post
    commenter = FactoryGirl.create(:commenter)
    login_as(commenter)
    visit root_path
    click_on post.title
    fill_in "comment_text_post_#{post.id}", with: "eh?"
    click_on "comment"
    expect(page).to have_content "eh?"
    expect(page).to have_content commenter.username
  end

  it "requires the user to be logged in", js: true do
    poster = FactoryGirl.create(:poster)
    post = FactoryGirl.create(:post)
    poster.posts << post
    commenter = FactoryGirl.create(:commenter)
    visit root_path
    click_on post.title
    fill_in "comment_text_post_#{post.id}", with: "eh?"
    click_on "comment"
    expect(page).to have_content "You must be logged in to do that."
  end
end
