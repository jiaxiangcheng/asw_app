require 'rails_helper'

# Test suite for the Submission model
RSpec.describe Submission, type: :model do
  # Association test
  it { should have_many(:replies).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  # Validation tests
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:user) }

  it "has a valid factory" do
    a_user = create(:user)
    a_submission = create(:submission, user: a_user)
    expect(a_submission).to be_valid
  end
end
