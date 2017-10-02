require "rails_helper"

describe "signing up", js: true do
  context "when the password and password confirmation match" do
    it "shows a success message" do
      visit root_path

      click_on "Join Us"
      fill_in "username", with: "bencorn"
      fill_in "password", with: 'person1_pwd'
      fill_in "password confirmation", with: 'person1_pwd'
      fill_in "email", with: 'ben@gmail.com'
      click_on "join"

      expect(page).to have_content "Welcome!"
    end
  end

  context "when the password and confirmation are different" do
    it "shows an error message" do
      visit root_path

      click_on "Join Us"
      fill_in "username", with: "bencorn"
      fill_in "password", with: 'person1_pwd'
      fill_in "password confirmation", with: 'person2_pwd'
      fill_in "email", with: 'ben@gmail.com'
      click_on "join"

      expect(page).to have_content "Your account could not be created."
    end
  end

  context "when they have successfully signed up" do
    it "logs the user in" do
      visit root_path

      click_on "Join Us"
      fill_in "username", with: "bencorn"
      fill_in "password", with: 'person1_pwd'
      fill_in "password confirmation", with: 'person1_pwd'
      fill_in "email", with: 'ben@gmail.com'
      click_on "join"

      expect(page).to have_content "feed"
    end
  end
end
