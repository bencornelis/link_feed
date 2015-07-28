require Rails.root + "db/generator_methods.rb"

user_count = 200
generate_users(user_count)
User.create(username: "watiki",
            password: "asdf",
            email:    "ben@gmail.com")

generate_user_activity(
  user_count:            user_count,
  max_posts_per_user:    5,
  max_comments_per_user: 50,
  max_follows_per_user:  15,
  max_shares_per_user:   25
)
