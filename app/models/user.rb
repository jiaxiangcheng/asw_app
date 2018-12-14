class User < ApplicationRecord
  has_many :submissions, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one :token, dependent: :destroy
  acts_as_voter
  validates :provider, presence: true
  validates :uid, presence: true
  validates :name, presence: true
  validates :email, presence: true

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      # user.provider = auth.provider -> set by first_or_initialize
      # user.uid = auth.uid -> set by first_or_initialize
      user.name = auth.info.name
      user.email = auth.info.email
      user.save!
    end
  end
end
