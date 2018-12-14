class SessionsController < ApplicationController
    def create
      login_response = request.env["omniauth.auth"]
      @auth = login_response['credentials']
        user = User.from_omniauth(login_response)
        Token.create(
          access_token: @auth['token'],
          refresh_token: @auth['refresh_token'],
          expires_at: Time.at(@auth['expires_at']).to_datetime,
          user: user
        ) # create also saves
        session[:user_id] = user.id
        redirect_to root_path
      end

      def destroy
        if session[:user_id] && User.exists?(session[:user_id])
          user = User.find(session[:user_id])
          user.token.destroy
        end
        session[:user_id] = nil
        redirect_to root_path
      end
end
