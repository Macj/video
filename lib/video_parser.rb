require 'video_parser/youtube'
require 'video_parser/vimeo'
require 'nokogiri'
require 'open-uri'
require 'openssl'
require 'net/http'
require 'net/https'
require 'active_support'

module VideoParser
  def self.parse_video_params url, token
    if url.match(/youtube.com/)
      Youtube.get_link url
    elsif url.match(/vimeo.com/)
      Vimeo.get_content url
    elsif url.match(/vk/)
      Vk.get_link url, token
    end
  end
end