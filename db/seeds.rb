require Rails.root + "db/user_activity_seeds.rb"

# special users
test_admin = User.new(username: "admin",
                      email: "admin@gmail.com",
                      password: "password2",
                      password_confirmation: "password2")

test_user = User.new(username: "testuser",
                     email: "ben@gmail.com",
                     password: "password1",
                     password_confirmation: "password1")

test_moderator = User.new(username: "moderator",
                          email: "mod@gmail.com",
                          password: "password3",
                          password_confirmation: "password3")

test_users = [test_admin, test_user, test_moderator]
test_users.each(&:skip_confirmation!)
test_users.each(&:save!)

# assign test_user some badges to give
100.times { test_user.badges.create }

test_admin.add_role :admin
test_moderator.add_role :moderator

generate_user_activity(
  user_count:            50,
  max_posts_per_user:    20,
  max_comments_per_user: 125,
  max_follows_per_user:  20,
  max_shares_per_user:   300
)
