require "rails_helper"
require "validates_email_format_of/rspec_matcher"

RSpec.describe User, type: :model do
  it { should validate_presence_of :username }
  it { should validate_uniqueness_of :username }
  it { should validate_email_format_of :email }
  it { should have_many :posts }
  it { should have_many :comments }
  it { should have_many :shares }
  it { should have_many :shared_posts }
  it { should have_many :shared_comments }
  it { should have_many :shares_received }
  it { should have_many :followers }
  it { should have_many :followees }
  it { should have_many :badges }
  it { should have_many :badges_to_give }
  it { should have_many :badges_given }
  it { should have_many :badgings_received }

  describe '#following?' do
    let(:user)       { create :user }
    let(:other_user) { create :user }

    context 'when following another user' do
      it 'is true' do
        user.followees << other_user

        expect(user.following?(other_user)).to be true
      end
    end

    context 'when not following another user' do
      it 'is false' do
        expect(user.following?(other_user)).to be false
      end
    end
  end

  describe '#shared_post?' do
    let(:user) { create :user }
    let(:post) { create :post }

    context 'when the user has shared the post' do
      it 'is true' do
        user.shared_posts << post

        expect(user.shared_post?(post)).to be true
      end
    end

    context 'when the user has not shared the post' do
      it 'is false' do
        expect(user.shared_post?(post)).to be false
      end
    end
  end

  describe '#shared_comment?' do
    let(:user)    { create :user }
    let(:comment) { create :comment }

    context 'when the user has shared the comment' do
      it 'is true' do
        user.shared_comments << comment

        expect(user.shared_comment?(comment)).to be true
      end
    end

    context 'when the user has not shared the comment' do
      it 'is false' do
        expect(user.shared_comment?(comment)).to be false
      end
    end
  end

  describe '#followee_follow' do
    let(:follow)     { create :follow }
    let(:user)       { follow.followee }
    let(:other_user) { follow.follower }

    it 'returns the follow having another user as follower' do
      expect(user.followee_follow(other_user)).to eql follow
    end
  end
end
