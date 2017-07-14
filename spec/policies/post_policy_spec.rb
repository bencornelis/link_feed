require "rails_helper"

describe PostPolicy do
  subject { described_class.new(user, post) }

  context "for a visitor" do
    let(:user) { nil }
    let(:post) { create(:post) }

    it { should forbid_actions([:edit, :update, :destroy, :share]) }
  end

  context "for an admin" do
    let(:user) do
      create(:user) { |user| user.add_role :admin }
    end

    let(:post) { create(:post) }

    it { should permit_actions([:edit, :update, :destroy]) }
  end

  context "for the poster" do
    let(:user) do
      create(:user) { |user| user.add_role :admin }
    end

    let(:post) do
      create(:post) { |post| post.user = user }
    end

    it { should permit_actions([:edit, :update, :destroy]) }
    it { should forbid_action(:share) }
  end

  context "for a user other than the poster" do
    let(:user) { create(:user) }
    let(:post) { create(:post) }

    it { should forbid_actions([:edit, :update, :destroy]) }
    it { should permit_action(:share) }
  end

  context "for a user that has already shared the post" do
    let(:user) { create(:user) }
    let(:post) do
      create(:post) { |post| post.users_shared_by << user }
    end

    it { should forbid_action(:share) }
  end
end
