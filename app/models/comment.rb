class Comment < ApplicationRecord
  belongs_to :user
  validates :user, :presence => true
  belongs_to :submission
  validates :submission, :presence => true
  acts_as_votable
  belongs_to :parent, polymorphic: true, inverse_of: :replies, optional: true
  has_many   :replies, as: :parent, class_name: "Comment", inverse_of: :parent, dependent: :destroy
end
