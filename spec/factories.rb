FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "person#{n}" }
    sequence(:password) { |n| "person#{n}pwd" }
    sequence(:email)    { |n| "person#{n}@gmail.com" }
  end

  factory :post do
    title "What do you think?"
    url ""
    tag1_name "questions"
    tag2_name "thinking"
  end

  factory :comment do
    sequence(:text) { |n| "the number #{n} is my favorite! "}
  end
end
