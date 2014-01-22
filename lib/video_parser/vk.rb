require 'video_parser/nokogiri_parser'
require 'openssl'
require 'net/http'
require 'net/https'
require 'active_support'

module VideoParser
  class Vk
    def self.get_link url, token
      if url.match(/z=video/)
        video_code = url[/z=video(.*?)%/,1]
      else
        video_code = url.slice(/([\d|_]*)$/)
      end
      video_get_link = "https://api.vk.com/method/video.get?videos=#{video_code}&access_token=#{token}"
      uri = URI.parse(video_get_link)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)
      @data = ActiveSupport::JSON.decode(response.body)["response"][1]
      title = @data["title"].to_s
      description = @data["description"].to_s
      player = @data["player"].to_s
      image_url = @data["image_medium"]

      if player.match(/youtube/)
        direct_link = youtube_link(player)
      elsif player.match(/vimeo/)
        data = vimeo_link(player)
        direct_link = data[:direct_link]
        image_url = data[:image_url]
      elsif player.match(/vk/)
        direct_link = vk_link(player)
      end

      data = { :title => title, :description => description, :player => player, :link => direct_link, :image_url => image_url }
    end

    def self.youtube_link player
      player.gsub('/embed/', '/watch?v=')
    end

    def self.vimeo_link player
      Vimeo.get_vimeo_link(player)
    end

    def self.vk_link player
      doc = NokogiriParser.get_doc(player)
      elem = doc.xpath('//param[@name="flashvars"]').attribute("value").to_s
      direct_link = elem[/url240=(.*?)&/,1]
    end
  end
end