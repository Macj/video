#encoding: utf-8
require 'nokogiri'
require 'open-uri'
require 'openssl'
require 'net/http'
require 'net/https'

module VideoParser
  def self.parse_video_params url, token
    if url.match(/youtube/)
      doc = Nokogiri::HTML(open(url))
      doc.encoding = 'utf-8'
      title = doc.at_css('h1 span').content.gsub(/\s/, "")
      description = doc.at_xpath("//p[@id='eow-description']").content
      data = { :title => title, :description => description }
    elsif url.match(/vimeo/)
      doc = Nokogiri::HTML(open(url))
      doc.encoding = 'utf-8'
      title = doc.at_css('h1').content
      if doc.at_css('div.description.read_more.collapsed')
        description = doc.at_css('div.description.read_more.collapsed > p.first').content
      else
        description = doc.at_css('div.description > p.first').content
      end

      data = { :title => title, :description => description }
    elsif url.match(/vk/)
      #for videos from communities
      if url.match(/z=/)
        video_code = url[/.*z=video([^%2F]*)/,1]
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
      data = { :title => title, :description => description, :player => player }
    end
  end
end