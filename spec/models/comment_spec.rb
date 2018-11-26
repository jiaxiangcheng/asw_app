require 'rails_helper'

# Test suite for the Comment model
RSpec.describe Comment, type: :model do
  # Association test
  it { should have_many(:replies).dependent(:destroy) }
  # Validation tests
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:submission) }
  it { should validate_presence_of(:parent) }
end
