class SessionsController < ApplicationController
  def create
    user = User.from_omniauth(env["omniauth.auth"])
    sign_in(:user, user)
    session[:user_id] = user.id
    session[:vk_token] = env["omniauth.auth"]["credentials"]["token"]
    puts session[:vk_token]
    first_name = env["omniauth.auth"]["info"]["first_name"]
    last_name = env["omniauth.auth"]["info"]["last_name"]
    flash[:notice] = "Добро пожаловать, #{first_name} #{last_name}! Вы вошли!"
    redirect_to root_url
  end

  def sign_in_page
  end
end