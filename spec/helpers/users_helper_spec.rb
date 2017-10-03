require 'rails_helper'

RSpec.describe UsersHelper, type: :helper do
  describe '#user_link_class' do
    let(:helper) do
      Class.new do
        include UsersHelper
        def current_user
          @current_user ||= FactoryGirl.create(:user)
        end
      end.new
    end

    let(:link_class)   { helper.user_link_class(user) }

    context 'when the user is an admin' do
      let(:user) { create :user, :admin }

      it "returns the 'admin' class" do
        expect(link_class).to eql 'admin'
      end
    end

    context 'when the user is a moderator' do
      let(:user) { create :user, :moderator }

      it "returns the 'moderator' class" do
        expect(link_class).to eql 'moderator'
      end
    end

    context 'when the current user is following the user' do
      let(:current_user) { helper.current_user }
      let(:user) do
        create :user do |user|
          user.followers << current_user
        end
      end

      it "returns the 'following' class" do
        expect(link_class).to eql 'following'
      end
    end

    context 'otherwise' do
      let(:user) { create :user }

      it "returns the 'regular' class" do
        expect(link_class).to eql 'regular'
      end
    end
  end
end
