#encoding: utf-8
require 'nokogiri'
require 'open-uri'
require 'openssl'
require 'net/http'
require 'net/https'
require 'active_support/all'
require 'viddl-rb'

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
      if url.match(/videos/)
        video_code = url.sub(/.*videos/, '')
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
      puts player

      ####### for getting direct link to the different sources from vk
      if player.match(/youtube/)
        ViddlRb.get_urls(player)
      elsif player.match(/vk/)
        doc = Nokogiri::HTML(open(player))
        doc.encoding = 'utf-8'
        elem = doc.xpath('//param[@name="flashvars"]').attribute("value").to_s
        direct_link = elem[/url240=(.*?)&/,1]
      elsif player.match(/vimeo/)
        doc = Nokogiri::HTML(open(player))
        doc.encoding = 'utf-8'
        puts doc
      end
      # puts "DATA", @data
      data = { :title => title, :description => description, :player => player }
    end
  end

  #parse_video_params("https://vk.com/video208400051_165603436", "3e1d912e0d9663af90967aff2094d1f585fc663170685ec6fd8faa67f5a55cb267c60ea7e0e7975de9d76")
end