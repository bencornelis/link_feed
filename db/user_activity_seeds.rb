def random_time_after(start)
  Time.at(start + rand * (Time.zone.now - start))
end

def random_id(resource_count)
  rand(resource_count) + 1
end

def generate_users(user_count)
  users = []
  user_count.times do
    password = Faker::Internet.password(8)
    user_params = {
      username:              Faker::Internet.user_name,
      email:                 Faker::Internet.email,
      password:              password,
      password_confirmation: password
    }

    Timecop.freeze(rand(100).days.ago) do
      user = User.new(user_params)
      user.skip_confirmation!
      user.save(validate: false)

      users << user
    end
  end

  users
end

def generate_user_activity(options)
  puts 'generating users...'
  users = generate_users(options[:user_count])

  puts 'generating posts...'
  users.each do |user|
    rand(options[:max_posts_per_user]).times do
      Timecop.freeze(random_time_after(user.created_at)) do
        if rand < 0.5
          post = user.posts.create(
            title:     Faker::Company.catch_phrase,
            url:       Faker::Internet.url,
            text:      Faker::Hacker.say_something_smart,
            tag_names: [Faker::Hacker.adjective, Faker::Hacker.abbreviation]
          )
        else
          post = user.posts.create(
            title:     Faker::Hacker.say_something_smart,
            url:       "",
            text:      Faker::Hacker.say_something_smart,
            tag_names: [Faker::Hacker.adjective, Faker::Hacker.abbreviation]
          )
        end

        user.shared_posts << post
      end
    end
  end

  puts 'generating comments...'
  users.each do |user|
    comments_count = rand(options[:max_comments_per_user])
    posts = Post.order('RANDOM()').limit(random_id(comments_count))

    comments_count.times do
      post = posts.sample

      Timecop.freeze(random_time_after([user.created_at, post.created_at].max)) do
        text = (rand < 0.5) ? Faker::Lorem.sentence :
                              Faker::Hacker.say_something_smart

        if rand < 0.5 && post.comments.exists?
          # create a child comment
          parent_id = post.comments.order('RANDOM()').first.id
          comment = post.comments.create(
            user_id:   user.id,
            parent_id: parent_id,
            text:      text
          )
        else
          # create a root comment
          comment = post.comments.create(
            user_id: user.id,
            text:    text
          )
        end

        user.shared_comments << comment
      end
    end
  end

  posts_count    = Post.count
  comments_count = Comment.count

  puts 'generating follows, shares, and badges...'
  users.each do |user|
    rand(options[:max_follows_per_user]).times do
      user.follower_follows.create(followee_id: random_id(options[:user_count]))
    end

    rand(options[:max_shares_per_user]).times do
      if rand < 0.25
        shareable_id = random_id(posts_count)
        share_receiver = Post.find(shareable_id).user
        user
          .shares
          .create(shareable_id: shareable_id,
                  shareable_type: 'Post',
                  share_receiver_id: share_receiver.id)
      else
        shareable_id = random_id(comments_count)
        share_receiver = Comment.find(shareable_id).user
        user
          .shares
          .create(shareable_id: shareable_id,
                  shareable_type: 'Comment',
                  share_receiver_id: share_receiver.id)
      end

      share_receiver.shares_received_since_last_badge += 1
      if share_receiver.shares_received_since_last_badge == 10
        share_receiver.badges.create
        share_receiver.shares_received_since_last_badge = 0
      end
      share_receiver.save
    end
  end

  puts 'generating badgings...'
  users.each do |user|
    badge_count = user.badges.count
    badges_to_give_count = badge_count/2

    posts_to_badge = Post.order('RANDOM()').limit(badges_to_give_count/4)
    comments_to_badge = Comment.order('RANDOM()').limit(3 * badges_to_give_count/4)

    (posts_to_badge + comments_to_badge).each do |badgeable|
      badge = user.badges_to_give.first
      badge_receiver = badgeable.user

      badgeable.badgings.create(
        badge_id: badge.id,
        badge_receiver_id: badge_receiver.id
      )

      badge.update!(given: true)
    end
  end
end
