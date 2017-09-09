FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "person#{n}" }
    sequence(:password) { |n| "person#{n}pwd" }
    sequence(:email)    { |n| "person#{n}@gmail.com" }
  end

  factory :post do
    sequence(:title) { |n| "Title #{n}" }
    url ""
    tag_names "Tag1 Tag2"
    user
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
