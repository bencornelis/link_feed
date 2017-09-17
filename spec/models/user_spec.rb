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
end
