class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :submission
  acts_as_votable
end
