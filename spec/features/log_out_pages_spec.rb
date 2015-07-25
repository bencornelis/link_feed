require "rails_helper"

describe "logging out" do
  it "logs out a currently logged in user" do
    user = FactoryGirl.create(:user)
    login_as(user)
    click_on "Logout"
    expect(page).to have_content "Login | Join Us"
  end
end
