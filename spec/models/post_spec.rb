require 'rails_helper'

RSpec.describe Post, type: :model do
  it { should validate_presence_of :title }
  it { should have_many :comments }
  it { should belong_to :user }
  it { should have_many :users_shared_by}
  it { should have_and_belong_to_many :tags }

  it "can have no more than 2 tags" do
    post = FactoryGirl.build(:post)
    music_tag = FactoryGirl.create(:music_tag)
    gaming_tag = FactoryGirl.create(:gaming_tag)
    soundtracks_tag = FactoryGirl.create(:soundtracks_tag)
    post.tags << music_tag
    post.tags << gaming_tag
    post.tags << soundtracks_tag
    
    expect(post.save).to eq false
  end
end
