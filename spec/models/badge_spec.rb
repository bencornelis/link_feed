require 'rails_helper'

RSpec.describe Badge, type: :model do
  it { should belong_to :badge_giver }
end
