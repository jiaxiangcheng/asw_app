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

  it "has a valid factory" do
    a_user = create(:user)
    a_submission = create(:submission, user: a_user)
    a_comment = create(:comment, :to_submission, user: a_user, submission: a_submission, parent: a_submission)
    expect(a_comment).to be_valid
  end
end
