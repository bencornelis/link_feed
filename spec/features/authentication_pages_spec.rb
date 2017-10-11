require "rails_helper"

describe "signing up" do
  context "when they have successfully signed up" do
    it "sends a confirmation email" do
      visit root_path
      click_on "Join Us"

      within "form" do
        fill_in "username", with: "bencorn"
        fill_in "password", with: 'person1_pwd'
        fill_in "password confirmation", with: 'person1_pwd'
        fill_in "email", with: 'ben@gmail.com'
        click_on "join"
      end

      expect(page)
        .to have_content I18n.t("devise.registrations.signed_up_but_unconfirmed")
    end
  end

  context "when they enter invalid information" do
    it "shows the errors" do
      visit root_path
      click_on "Join Us"

      within "form" do
        fill_in "username", with: "bencorn"
        fill_in "password", with: 'foo'
        fill_in "password confirmation", with: 'bar'
        fill_in "email", with: 'ben@gmail'
        click_on "join"
      end

      expect(page)
        .to have_content "Password confirmation doesn't match Password"

      expect(page)
        .to have_content "Password is too short (minimum is 6 characters)"

      expect(page)
        .to have_content "Email does not appear to be a valid e-mail address"
    end
  end
end

describe "signing in" do
  context "when they enter the correct information" do
    it "logs the user in" do
      user = create :user

      visit root_path
      click_on "Login"

      within "form" do
        fill_in "username", with: user.username
        fill_in "password", with: user.password
        click_on "login"
      end

      expect(page)
        .to have_content I18n.t("devise.sessions.signed_in")
    end
  end

  context "when they enter incorrect information" do
    it "shows an error message" do
      user = create :user

      visit root_path
      click_on "Login"

      within "form" do
        fill_in "username", with: user.username
        fill_in "password", with: "foobar"
        click_on "login"
      end

      expect(page)
        .to have_content "Invalid Username or password."
    end
  end
end