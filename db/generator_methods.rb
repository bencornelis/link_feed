def random(number)
  rand(number) + 1
end

def generate_users(user_count)
  users = []
  user_count.times do
    password = Faker::Internet.password(8)
    users << {
      username:              Faker::Internet.user_name,
      email:                 Faker::Internet.email,
      password:              password,
      password_confirmation: password
    }
  end
  User.create(users)
end

def generate_user_activity(options)
  user_count, post_count, comment_count = options[:user_count], 0, 0

  user_count.times do |count|
    user_id = count + 1

    # generate posts
    rand(options[:max_posts_per_user]).times do |i|
      Timecop.freeze(rand(100).days.ago) do
        if i % 2 == 0
          Post.create(
            title:        Faker::Company.catch_phrase,
            url:          Faker::Internet.url,
            text:         Faker::Hacker.say_something_smart,
            user_id:      user_id,
            tag_names:    "#{Faker::Hacker.adjective} #{Faker::Hacker.abbreviation}",
          )
        else
          Post.create(
            title:        Faker::Hacker.say_something_smart,
            url:          "",
            text:         Faker::Hacker.say_something_smart,
            user_id:      user_id,
            tag_names:    "#{Faker::Hacker.adjective} #{Faker::Hacker.abbreviation}",
          )
        end
      end
      post_count += 1
    end

    # generate comments
    rand(options[:max_comments_per_user]).times do |i|
      text = i % 2 == 0 ? Faker::Lorem.sentence : Faker::Hacker.say_something_smart

      if i % 3 == 0 || comment_count == 0
        # create a top level comment on a post
        Comment.create(
          user_id:          user_id,
          text:             text,
          post_id:          random(post_count),
          parent_id:        nil
        )
      else
        # create a comment on a comment
        parent_id = random(comment_count)
        post_id = Comment.find(parent_id).post_id
        Comment.create(
          user_id:          user_id,
          text:             text,
          post_id:          post_id,
          parent_id:        parent_id
        )
      end

      comment_count += 1
    end

    # generate follows
    rand(options[:max_follows_per_user]).times do
      Follow.create(follower_id: user_id,
                    followee_id: random(user_count))
    end

    # generate shares
    rand(options[:max_shares_per_user]).times do
      Share.create(user_id: user_id,
                   post_id: random(post_count))
    end
  end
end
