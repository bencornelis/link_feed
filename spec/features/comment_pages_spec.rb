require "rails_helper"

describe "adding a top level comment to a post", js: true do
  it "puts the new comment at the top" do
    post = create :post
    user = create :user

    login_as(user)
    visit post_path(post)

    fill_in "comment_text", with: "eh?"
    click_on "comment"

    expect(page).to have_content "eh?"
    expect(page).to have_content user.username
  end

  it "requires the user to be logged in", js: true do
    post = create :post

    visit post_path(post)

    fill_in "comment_text", with: "eh?"
    click_on "comment"

    expect(page).to have_content "You must be logged in to do that."
  end
end

describe "commenting on a comment", js: true do
  it "puts the new comment at the top" do
    comment = create :comment
    user    = create :user

    login_as(user)
    visit post_path(comment.post)

    within("li#comment_#{comment.id}") do
      click_link "reply"
      fill_in "comment_text", with: "eh?"
      click_on "comment"
    end

    expect(page).to have_content "eh?"
    expect(page).to have_content user.username
    expect(page).to have_content "parent"
    expect(page).to have_content "edit"
    expect(page).to have_content "delete"
  end
end

describe "editing a comment", js: true do
  it "lets a user edit their comment" do
    comment = create :comment

    login_as(comment.user)
    visit post_path(comment.post)

    old_comment_text = comment.text
    click_on "edit"
    find(:css, "#edit_comment_#{comment.id}")
      .fill_in "comment_text", with: "some new text"
    click_on "submit edit"

    expect(page).to have_no_content old_comment_text
    expect(page).to have_no_content "submit edit"
    expect(page).to have_content    "some new text"
  end
end

describe "deleting a comment", js: true do
  it "lets a user delete their comment" do
    comment = create :comment
    user    = comment.user

    login_as(user)
    visit post_path(comment.post)

    expect(page).to have_content user.username
    expect(page).to have_content comment.text

    click_on "delete"
    expect(page).to have_no_content user.username
    expect(page).to have_no_content comment.text
  end
end

describe "viewing all comments" do
  it "displays all comments" do
    create :comment, text: "Great post!"
    create :comment, text: "I agree!"

    visit root_path
    click_on "comments"

    expect(page).to have_content "Great post!"
    expect(page).to have_content "I agree!"
  end
end
