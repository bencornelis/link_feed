require 'rails_helper'

RSpec.describe Post, type: :model do
  it { should validate_presence_of :title }
  it { should have_many :comments }
  it { should have_and_belong_to_many :tags }
  it { should belong_to :user }
  it { should have_many :users_shared_by}
  it { should }
end
