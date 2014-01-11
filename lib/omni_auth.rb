require 'omniauth-vkontakte'
require 'uri'
require 'net/http'
require 'net/https'
require 'openssl'

module OmniAuth
  def self.get_vk_access_token app_id, app_secret, code
    uri = URI.parse('https://api.vk.com/oauth/access_token?')
    uri.query = URI.encode_www_form( { 'client_id' => app_id, 'client_secret' => app_secret, 'code' => code, 'redirect_uri' => 'http://localhost:3000/' } )

    puts "URI", uri
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    @data = response.body
    puts "BODY", @data
  end
end