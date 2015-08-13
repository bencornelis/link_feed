require Rails.root + "db/generator_methods.rb"

user_count = 20
generate_users(user_count)

test_user = User.create(username: "watiki",
                        password: "asdf",
                        email: "ben@gmail.com")

test_admin = User.create(username: "admin",
                         password: "1234",
                         email: "admin@gmail.com")
test_admin.add_role :admin

test_moderator = User.create(username: "moderator",
                             password: "5768",
                             email:    "mod@gmail.com")                           
test_moderator.add_role :moderator

generate_user_activity(
  user_count:            user_count,
  max_posts_per_user:    10,
  max_comments_per_user: 50,
  max_follows_per_user:  20,
  max_shares_per_user:   20
)
