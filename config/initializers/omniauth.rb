Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV["GOOGLE_KEY"], ENV["GOOGLE_SECRET"]
  provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_SECRET'], { :scope => 'friends_videos, user_videos' }
  provider :vkontakte, ENV['API_KEY'], ENV['API_SECRET'], { :scope => 'video' }
end