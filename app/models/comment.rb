class Comment < ApplicationRecord
  validates :user, :presence => true
  validates :submission, :presence => true

  acts_as_votable

  belongs_to :user
  belongs_to :submission
  belongs_to :parent, polymorphic: true, inverse_of: :replies, optional: true
  has_many   :replies, as: :parent, class_name: "Comment", inverse_of: :parent, dependent: :destroy
end
