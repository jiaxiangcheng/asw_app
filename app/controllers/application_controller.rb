class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token

  def current_user
    # refresh all session tokens
    Token.all {|t| t.refresh_if_expired }

    if session.key?(:user_id) && User.exists?(session[:user_id])
      # logged in
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    elsif request.headers.key?(:Token) && Token.exists?(access_token: request.headers[:Token])
      # API call with valid token
      token = Token.find_by(access_token: request.headers[:Token])
      @current_user = token.user
    elsif request.headers.key?(:Token) && User.exists?(name: request.headers[:Token])
      @current_user = User.find_by(name: request.headers[:Token])
    else
       # not authenticated
      @current_user = nil
    end
  end

  def user_is_logged?
    current_user != nil
  end

  helper_method :current_user, :user_is_logged?
end
