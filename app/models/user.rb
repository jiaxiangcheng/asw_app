class User < ApplicationRecord
  has_many :submissions, dependent: :destroy
  has_many :comments, dependent: :destroy
  acts_as_voter
  validates :provider, presence: true
  validates :uid, presence: true
  validates :name, presence: true
  validates :email, presence: true
  validates :token, presence: true
  
  def self.from_omniauth(auth)
      where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
        user.provider = auth.provider
        user.uid = auth.uid
        user.name = auth.info.name
        user.email = auth.info.email
        user.token = auth.credentials.token
        user.save!
      end
    end
end
