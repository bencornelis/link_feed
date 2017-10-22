require 'rails_helper'

RSpec.describe Badging, type: :model do
  it { should belong_to :badge }
  it { should belong_to :badgeable }
  it { should belong_to :badge_receiver }
end

