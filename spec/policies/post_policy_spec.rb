require "rails_helper"

describe PostPolicy do
  subject { described_class.new(user, post) }

  context "for a visitor" do
    let(:user) { nil }
    let(:post) { create :post }

    it { should forbid_actions([:edit, :update, :destroy, :share]) }
  end

  context "for an admin" do
    let(:user) { create :user, :admin }
    let(:post) { create :post }

    it { should permit_actions([:edit, :update, :destroy]) }
  end

  context "for the poster" do
    let(:user) { post.user }
    let(:post) { create :post }

    it { should permit_actions([:edit, :update, :destroy]) }
    it { should forbid_action(:share) }
  end

  context "for a user other than the poster" do
    let(:user) { create :user }
    let(:post) { create :post }

    it { should forbid_actions([:edit, :update, :destroy]) }
    it { should permit_action(:share) }
  end

  context "for a user that has already shared the post" do
    let(:user) { create :user }
    let(:post) { create :post, users_shared_by: [user] }

    it { should forbid_action(:share) }
  end
end
