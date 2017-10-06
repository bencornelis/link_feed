require "rails_helper"

describe "clicking on a post title" do
  it "displays the post view for internal links" do
    post = create :post

    visit root_path
    click_on post.title

    expect(page).to have_content post.title
    expect(page).to have_content post.user.username
    expect(page).to have_content "0 shares"
  end
end

describe "navigating to a post" do
  it "links the title to the external url" do
    create :post, url: "https://nytimes.com"

    visit root_path

    click_on "0 comments"
    expect(page).to have_selector(:css, 'a[href="https://nytimes.com"]')
  end
end

describe "adding a post" do
  it "displays post information for a post just added" do
    user = create :user

    login_as(user)
    visit root_path

    click_on "new_post_link"
    fill_in "post_title", with: "What is the best games soundtrack?"
    fill_in "post_text", with: "I really want to know!"
    fill_in "post_tag_names", with: "games soundtracks"
    click_on "submit"

    expect(page).to have_content "What is the best games soundtrack?"
    expect(page).to have_content "I really want to know!"
    expect(page).to have_content "edit"
  end

  it "has the poster share the post" do
    user = create :user

    login_as(user)
    visit root_path

    click_on "new_post_link"
    fill_in "post_title", with: "What is the best games soundtrack?"
    fill_in "post_text", with: "I really want to know!"
    fill_in "post_tag_names", with: "games soundtracks"

    click_on "submit"
    expect(page).to have_content "1 share"

    click_on "Profile"
    expect(page).to have_content "1 share"
  end

  it "correctly adds the tags", js: true do
    user = create :user

    login_as(user)
    visit new_post_path
    fill_in "post_title", with: "What is the best games soundtrack?"
    fill_in "post_tag_names", with: "games soundtracks"
    click_on "submit"

    visit profile_path

    expect(page).to have_content "#games"
    expect(page).to have_content "#soundtracks"
  end

  it "requires a user to be logged in" do
    visit root_path

    click_on "new_post_link"

    expect(page).to have_content "You must be logged in to do that."
  end

  it "redirects back when the post is invalid" do
    login_as(create(:user))
    visit new_post_path

    click_on "submit"

    expect(page).to have_content "There was an error submitting your post."
    expect(page).to have_current_path new_post_path
  end
end

describe "sharing a post" do
  it "requires the user to be logged in", js: true do
    post = create :post

    visit post_path(post)

    expect(page).to have_content post.title

    find('.share_link').click

    expect(page).to have_content 'You must be logged in to do that.'
  end

  it "only lets the user share a post once", js: true do
    post = create :post
    user = create :user

    login_as(user)
    visit post_path(post)

    expect(page).to have_content "0 shares"

    find('.share_link').click
    expect(page).not_to have_selector '.share_link'
    expect(page).to have_content "1 share"

    visit profile_path
    expect(page).to have_content post.title
  end
end

describe "editing a post" do
  it "does not let regular users edit another's post" do
    post = create :post
    user = create :user

    login_as(user)
    visit post_path(post)

    expect(page).to have_no_content "edit"
  end

  it "lets a user edit their own post" do
    post = create :post

    login_as(post.user)
    visit post_path(post)

    click_on "edit"
    fill_in "title", with: "a new title"
    click_on "submit edit"

    expect(page).to have_no_content "submit edit"
    expect(page).to have_content "a new title"
  end
end

describe "deleting a post" do
  it "redirects the user to the home page" do
    post = create :post

    login_as(post.user)
    visit post_path(post)

    click_on "delete"

    expect(page).to have_content "Post successfully deleted."
    expect(page).to have_current_path root_path
  end
end

describe "sorting by recent" do
  it "displays the posts ordered by time" do
    # default is 10 posts per page
    (1..11).each do |n|
      Timecop.freeze((n+1).days.ago) do
        create :post, title: "Title #{n}"
      end
    end

    visit root_path
    click_on "recent"

    expect(page).to have_content "Title 1"
    expect(page).to have_no_content "Title 11"
  end
end

describe "filtering by tag" do
  it "displays only posts with the tag" do
    create :post, title: "Title 1", tag_names: "Tag1"
    create :post, title: "Title 2", tag_names: "Tag2"

    visit root_path
    click_on "#Tag1"

    expect(page).to have_content "Title 1"
    expect(page).to have_no_content "Title 2"
  end
end
