require "rails_helper"

describe "adding a top level comment to a post", js: true do
  it "puts the new comment at the top" do
    post = create_post
    commenter = create(:user)

    login_as(commenter)
    visit post_path(post)

    fill_in "comment_text", with: "eh?"
    click_on "comment"
    expect(page).to have_content "eh?"
    expect(page).to have_content commenter.username
  end

  it "requires the user to be logged in", js: true do
    post = create_post
    commenter = create(:user)

    visit post_path(post)

    fill_in "comment_text", with: "eh?"
    click_on "comment"
    expect(page).to have_content "You must be logged in to do that."
  end
end

describe "commenting on a comment", js: true do
  it "puts the new comment at the top" do
    post = create_post
    first_commenter = create(:user)
    comment = create(:comment)
    first_commenter.comments << comment
    post.comments << comment
    second_commenter = create(:user)

    login_as(second_commenter)
    visit post_path(post)

    within("li#comment_#{comment.id}") do
      click_link "reply"
      fill_in "comment_text", with: "eh?"
      click_on "comment"
    end

    expect(page).to have_content "eh?"
    expect(page).to have_content second_commenter.username
    expect(page).to have_content "parent"
    expect(page).to have_content "edit"
    expect(page).to have_content "delete"
  end
end

describe "editing a comment", js: true do
  it "lets a user edit their comment" do
    post = create_post
    commenter = create(:user)
    comment = create(:comment)
    commenter.comments << comment
    post.comments << comment

    login_as(commenter)
    visit post_path(post)

    old_comment_text = comment.text
    click_on "edit"
    find(:css, "#edit_comment_#{comment.id}").fill_in "comment_text", with: "some new text"
    click_on "submit edit"
    expect(page).to have_no_content old_comment_text
    expect(page).to have_no_content "submit edit"
    expect(page).to have_content "some new text"
  end
end

describe "deleting a comment", js: true do
  it "lets a user delete their comment" do
    post = create_post
    commenter = create(:user)
    comment = create(:comment)
    commenter.comments << comment
    post.comments << comment

    login_as(commenter)
    visit post_path(post)

    expect(page).to have_content commenter.username
    expect(page).to have_content comment.text

    click_on "delete"
    expect(page).to have_no_content commenter.username
    expect(page).to have_no_content comment.text
  end
end

describe "viewing all comments" do
  it "displays all comments by most recent" do
    new_comment =
      create(:comment, text: "Great post!") do |comment|
        create_post.comments << comment
        create(:user).comments << comment
      end

    visit root_path
    click_on "comments"
    expect(page).to have_content "Great post!"
  end
end
