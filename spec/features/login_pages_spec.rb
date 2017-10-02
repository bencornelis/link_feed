require "rails_helper"

describe 'logging in' do
  it 'redirects to the home page on successful login' do
    user = create :user

    visit root_path

    click_on 'Login'

    within 'form' do
      fill_in 'username', with: user.username
      fill_in 'password', with: user.password
      click_on 'login'
    end

    expect(page).to have_content("You've been logged in.")
  end

  it 'redirects to the login on failed login attempt' do
    user = create :user

    visit root_path

    click_on 'Login'

    within 'form' do
      fill_in 'username', with: "foo"
      fill_in 'password', with: user.password
      click_on 'login'
    end

    expect(page).to have_content("There was a problem logging you in.")
  end
end
