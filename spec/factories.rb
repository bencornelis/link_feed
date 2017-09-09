FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "person#{n}" }
    sequence(:password) { |n| "person#{n}pwd" }
    sequence(:email)    { |n| "person#{n}@gmail.com" }

    trait :admin do
      after(:create) do |user|
        user.add_role :admin
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
  end

  factory :post do
    sequence(:title) { |n| "Title #{n}" }
    url ""
    tag_names "Tag1 Tag2"
    user

    factory :post_with_shares do
      transient do
        shares_count 2
      end

      after(:create) do |post, evaluator|
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
  end
end
