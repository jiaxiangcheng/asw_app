require 'rails_helper'

# Test suite for the User model
RSpec.describe User, type: :model do
  # Association test
  it { should have_many(:submissions).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  # Validation tests
  it { should validate_presence_of(:provider) }
  it { should validate_presence_of(:uid) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:token) }
end
