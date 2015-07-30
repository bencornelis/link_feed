require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should validate_presence_of :text }
  it { should belong_to :user }
  it { should belong_to :commentable }
  it { should have_many :top_level_comments}
end
