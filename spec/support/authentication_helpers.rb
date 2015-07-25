def login_as(user)
  visit login_path
  fill_in 'username', with: user.username
  fill_in 'password', with: user.password
  click_on 'login'
end
