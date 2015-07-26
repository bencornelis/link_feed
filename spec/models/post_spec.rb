require 'rails_helper'

RSpec.describe Post, type: :model do
  it { should validate_presence_of :title }
  it { should have_many :comments }
  it { should belong_to :user }
  it { should have_many :users_shared_by }
  it { should have_many :taggings }
  it { should have_many :tags }
end
