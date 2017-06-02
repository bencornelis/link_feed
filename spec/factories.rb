FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "person#{n}" }
    sequence(:password) { |n| "person#{n}pwd" }
    sequence(:email)    { |n| "person#{n}@gmail.com" }
  end

  factory :post do
    title "Test Title"
    url ""
    tag1_name "Tag1"
    tag2_name "Tag2"
  end

  factory :comment do
    sequence(:text) { |n| "the number #{n} is my favorite! "}
  end
end
