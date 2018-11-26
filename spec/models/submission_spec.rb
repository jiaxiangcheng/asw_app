require 'rails_helper'

# Test suite for the Submission model
RSpec.describe Submission, type: :model do
  # Association test
  it { should have_many(:replies).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  # Validation tests
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:user) }
end
