require "rails_helper"

describe "clicking on a tag" do
  let!(:post1) { create :post, title: "Title 1", tag_names: ["tag1"] }
  let!(:post2) { create :post, title: "Title 2", tag_names: ["tag2"] }
  let!(:user)  { create :user }

  context "when the tag is recent" do
    it "displays all posts with that tag" do
      visit tags_path

      within("#recent_tags") do
        click_on "tag1"
      end

      expect(page).to have_content    "tag1"
      expect(page).to have_no_content "tag2"
    end
  end

  context "when the tag is popular" do
    it "displays all posts with that tag" do
      visit tags_path

      within("#popular_tags") do
        click_on "tag1"
      end

      expect(page).to have_content    "tag1"
      expect(page).to have_no_content "tag2"
    end
  end
end
