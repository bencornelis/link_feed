require "rails_helper"

describe CommentPolicy do
  subject { described_class.new(user, comment) }

  context "for a visitor" do
    let(:user) { nil }
    let(:comment) { create(:comment) }

    it { should forbid_actions([:edit, :update, :destroy]) }
  end

  context "for an admin" do
    let(:user) do
      create(:user) { |user| user.add_role :admin }
    end

    let(:comment) { create(:comment) }

    it { should permit_actions([:edit, :update, :destroy]) }
  end

  context "for a moderator" do
    let(:user) do
      create(:user) { |user| user.add_role :moderator }
    end

    let(:comment) { create(:comment) }

    it { should permit_actions([:edit, :update, :destroy]) }
  end

  context "for the commenter" do
    let(:user) { create(:user) }

    let(:comment) do
      create(:comment) { |comment| comment.user = user }
    end

    it { should permit_actions([:edit, :update, :destroy]) }
  end

  context "for a user other than the commenter" do
    let(:user) { create(:user) }
    let(:comment) { create(:comment) }

    it { should forbid_actions([:edit, :update, :destroy]) }
  end
end
