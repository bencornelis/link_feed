require "rails_helper"

describe "signing up" do
  it "shows a success message when the password and password confirmation match" do
    visit root_path

    click_on "Join Us"
    fill_in "username", with: "bencorn"
    fill_in "password", with: 12345678
    fill_in "password confirmation", with: 12345678
    fill_in "email", with: 'ben@gmail.com'
    click_on "join"

    expect(page).to have_content "Welcome!"
  end

  it "shows an error message when password and confirmation are different" do
    visit root_path

    click_on "Join Us"
    fill_in "username", with: "bencorn"
    fill_in "password", with: 12345678
    fill_in "password confirmation", with: 22345678
    fill_in "email", with: 'ben@gmail.com'
    click_on "join"

    expect(page).to have_content "Your account could not be created."
  end

  it "logs the user in when they have successfully signed up" do
    visit root_path

    click_on "Join Us"
    fill_in "username", with: "bencorn"
    fill_in "password", with: 12345678
    fill_in "password confirmation", with: 12345678
    fill_in "email", with: 'ben@gmail.com'
    click_on "join"
    
    expect(page).to have_content "feed"
  end
end
