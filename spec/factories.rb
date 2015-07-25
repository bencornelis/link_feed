FactoryGirl.define do
  factory :user do
    username "watiki"
    password "12345678"
    email "watiki@gmail.com"
  end

  factory :post do
    title "What are your favorite game soundtracks?"
  end

  factory :music_tag, class: Tag do
    name "music"
  end

  factory :gaming_tag, class: Tag do
    name "gaming"
  end

  factory :soundtracks_tag, class: Tag do
    name "soundtracks"
  end
end
