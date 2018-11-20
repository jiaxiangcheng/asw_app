class User < ApplicationRecord
  has_many :submissions
  has_many :comments
  acts_as_voter
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
