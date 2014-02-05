class SessionsController < ApplicationController
  def create
    user = User.from_omniauth(env["omniauth.auth"])
    sign_in(:user, user)
    session[:user_id] = user.id
    session[:vk_token] = env["omniauth.auth"]["credentials"]["token"]
    puts session[:vk_token]
    puts env["omniauth.auth"]
    first_name = env["omniauth.auth"]["info"]["first_name"]
    last_name = env["omniauth.auth"]["info"]["last_name"]
    flash[:notice] = "Добро пожаловать, #{first_name} #{last_name}! Вы вошли!"
    redirect_to root_url
  end

  def sign_in_page
    # token = params["token"]
    # puts params.inspect
    # puts "TOKEN", token
    # if !token.nil?
    #   url = 'http://ulogin.ru/token.php?token=#{token}'
    #   encoded_url = URI.encode(url)
    #   final_url = URI.parse(encoded_url)
    #   social_data = ActiveSupport::JSON.decode(Net::HTTP.get(final_url))
    #   puts "SOCIAL_DATA", social_data
    #   uid = social_data['identity']
    #   email = social_data['email']
    #   first_name = social_data['first_name']
    #   last_name = social_data['last_name']
    #   # sign_in(:user, user)
    #   # session[:user_id] = user.id
    #   # session[:vk_token] = env["omniauth.auth"]["credentials"]["token"]
    #   # puts session[:vk_token]
    #   # puts env["omniauth.auth"]
    #   # first_name = env["omniauth.auth"]["info"]["first_name"]
    #   # last_name = env["omniauth.auth"]["info"]["last_name"]
    #   flash[:notice] = "Добро пожаловать, #{first_name} #{last_name}! Вы вошли!"
    #   redirect_to root_url
    # end
  end
end