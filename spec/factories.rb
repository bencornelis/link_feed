FactoryGirl.define do
  factory :user do
    username "watiki"
    password "12345678"
    email "watiki@gmail.com"
  end

  factory :poster, class: User do
    username "andy"
    password "1234"
    email "andy@gmail.com"
  end

  factory :commenter, class: User do
    username "susan"
    password "longfang"
    email "susan@gmail.com"
  end

  factory :post do
    title "What do you think?"
    url ""
    tag1_name "questions"
    tag2_name "thinking"
  end

  factory :comment do
    text "Hmm, very interesting..."
  end
end
