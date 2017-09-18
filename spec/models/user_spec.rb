require "rails_helper"

RSpec.describe User, type: :model do
  it { should validate_presence_of :username }
  it { should validate_presence_of :email }
  it { should validate_confirmation_of :password }
  it { should have_many :posts }
  it { should have_many :comments }
  it { should have_many :shares }
  it { should have_many :shared_posts }
  it { should have_many :followers }
  it { should have_many :followees }

  describe '#followee_follow' do
    let(:follow)     { create :follow }
    let(:user)       { follow.followee }
    let(:other_user) { follow.follower }

    it 'returns the follow having another user as follower' do
      expect(user.followee_follow(other_user)).to eql follow
    end
  end
end
