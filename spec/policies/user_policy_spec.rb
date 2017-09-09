require "rails_helper"

describe UserPolicy do
  subject { described_class.new(user, other_user) }

  context "for a visitor" do
    let(:user)       { nil }
    let(:other_user) { create :user }

    it { should forbid_action(:follow) }
  end

  context "for the same user" do
    let(:user)       { create :user }
    let(:other_user) { user }

    it { should forbid_action(:follow) }
  end

  context "for another user already followed" do
    let(:user)       { create :user }
    let(:other_user) { create :user, followers: [user] }

    it { should forbid_action(:follow) }
  end

  context "for another user not already followed" do
    let(:user)       { create :user }
    let(:other_user) { create :user }

    it { should permit_action(:follow) }
  end
end
