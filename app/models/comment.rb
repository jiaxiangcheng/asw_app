class Comment < ApplicationRecord
  belongs_to :user
  validates :user, :presence => true
  belongs_to :submission
  validates :submission, :presence => true
  acts_as_votable
end
