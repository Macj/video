require 'omni_auth'

class SessionsController < ApplicationController
  def create
    user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
    OmniAuth.get_vk_access_token(ENV['API_KEY'], ENV['API_SECRET'], params[:code])
    redirect_to root_url
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end
end