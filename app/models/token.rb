require 'net/http'
require 'json'

class Token < ActiveRecord::Base
  belongs_to :user
  validates :access_token, :presence => true
  validates :refresh_token, :presence => true
  validates :expires_at, :presence => true
  validates :user, :presence => true

  def to_params
    {'refresh_token' => refresh_token,
    'client_id' => Rails.application.secrets.google_oauth2_part1,
    'client_secret' => Rails.application.secrets.google_oauth2_part2,
    'grant_type' => 'refresh_token'}
  end

  def request_token_from_google
    url = URI("https://accounts.google.com/o/oauth2/token")
    Net::HTTP.post_form(url, self.to_params)
  end

  def refresh!
    response = request_token_from_google
    data = JSON.parse(response.body)
    update_attributes(
    access_token: data['access_token'],
    expires_at: Time.now + (data['expires_in'].to_i).seconds)
  end

  def expired?
    expires_at < Time.now
  end

  def refresh_if_expired
    refresh! if expired?
  end

  def current_token
    refresh_if_expired
    access_token
  end
end
