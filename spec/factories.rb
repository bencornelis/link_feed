FactoryGirl.define do
  factory :user, aliases: [:follower, :followee] do
    sequence(:username)              { |n| "person#{n}" }
    sequence(:email)                 { |n| "person#{n}@gmail.com" }
    sequence(:password)              { |n| "person#{n}_pwd" }
    sequence(:password_confirmation) { |n| "person#{n}_pwd" }
    confirmed_at { Time.zone.now }

    trait :admin do
      after(:create) do |user|
        user.add_role :admin
      end
    end

    trait :moderator do
      after(:create) do |user|
        user.add_role :moderator
      end
    end

    factory :user_with_followees do
      transient do
        followees_count 2
      end

      after(:create) do |user, evaluator|
        create_list :user, evaluator.followees_count, followers: [user]
      end
    end

    factory :user_with_badges do
      transient do
        badges_count 2
      end

      after(:create) do |user, evaluator|
        create_list :badge, evaluator.badges_count, badge_giver: user
      end
    end
  end

  factory :post do
    sequence(:title) { |n| "Title #{n}" }
    url ""
    user

    factory :post_with_shares do
      transient do
        shares_count 2
      end

      after(:create) do |post, evaluator|
        create_list :user, evaluator.shares_count, shared_posts: [post]
      end
    end

    factory :post_with_shares_and_badgings do
      transient do
        badgings_count 2
        shares_count 2
      end

      after(:create) do |post, evaluator|
        create_list :badging, evaluator.badgings_count, badgeable: post
        create_list :user, evaluator.shares_count, shared_posts: [post]
      end
    end
  end

  factory :tag do
    sequence(:name) { |n| "Tag#{n}"}
  end

  factory :comment do
    sequence(:text) { |n| "the number #{n} is my favorite! "}
    user
    post

    factory :comment_with_shares do
      transient do
        shares_count 2
      end

      after(:create) do |comment, evaluator|
        create_list :user, evaluator.shares_count, shared_comments: [comment]
      end
    end

    factory :comment_with_shares_and_badgings do
      transient do
        badgings_count 2
        shares_count 2
      end

      after(:create) do |comment, evaluator|
        create_list :badging, evaluator.badgings_count, badgeable: comment
        create_list :user, evaluator.shares_count, shared_comments: [comment]
      end
    end
  end

  factory :follow do
    follower
    followee
  end

  factory :badge do
    association :badge_giver, factory: :user
  end

  factory :badging do
  end
end
