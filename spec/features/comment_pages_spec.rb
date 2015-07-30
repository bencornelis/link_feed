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
    fill_in "comment_text", with: "eh?"
    click_on "comment"
    expect(page).to have_content "eh?"
    expect(page).to have_content commenter.username
  end
end
