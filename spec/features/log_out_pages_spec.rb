require "rails_helper"

describe "logging out" do
  it "logs out a currently logged in user" do
    login_as(create(:user))
    click_on "Logout"

    expect(page).to have_content "Login | Join Us"
  end
end
