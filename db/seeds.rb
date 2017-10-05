require Rails.root + "db/generator_methods.rb"

user_count = 20
generate_users(user_count)

test_user = User.new(username: "watiki",
                     email: "ben@gmail.com",
                     password: "password1",
                     password_confirmation: "password1")

test_admin = User.new(username: "admin",
                      email: "admin@gmail.com",
                      password: "password2",
                      password_confirmation: "password2")

test_moderator = User.new(username: "moderator",
                          email: "mod@gmail.com",
                          password: "password3",
                          password_confirmation: "password3")

test_users = [test_user, test_admin, test_moderator]
test_users.each(&:skip_confirmation!)
test_users.each(&:save!)

test_admin.add_role :admin
test_moderator.add_role :moderator

generate_user_activity(
  user_count:            user_count,
  max_posts_per_user:    10,
  max_comments_per_user: 50,
  max_follows_per_user:  20,
  max_shares_per_user:   20
)
