require 'video_parser/nokogiri_parser'

module VideoParser
  class Vimeo
    def self.get_content url
      doc = NokogiriParser.get_doc(url)
      title = doc.at_css('h1').content
      if doc.at_css('div.description.read_more.collapsed')
        description = doc.at_css('div.description.read_more.collapsed > p.first').content
      else
        description = doc.at_css('div.description > p.first').content
      end
      url = url.insert(8, 'player.').insert(25, 'video/')
      data = get_vimeo_link(url)
      direct_link = data[:direct_link]
      image_url = data[:image_url]
      data = { :title => title, :description => description, :player => url, :link => direct_link, :image_url => image_url }
    end

    def self.get_vimeo_link url
      doc = NokogiriParser.get_doc(url)
      script = doc.at('script').text.to_s
      if script.match(/\"allow_hd\":1/) and script.match(/\"hd\":1/)
        hd = script.scan(/\"hd\":{(.*)}/).to_s
        direct_link = hd[/\\\"url\\\":\\\"(.*?)\\\",/,1]
      elsif script.match(/\"allow_hd\":0/)
        sd = script.scan(/\"sd\":{(.*)}/).to_s
        direct_link = sd[/\\\"url\\\":\\\"(.*?)\\\",/,1]
      else
        sd = script.scan(/\"sd\":{(.*)}/).to_s
        direct_link = sd[/\\\"url\\\":\\\"(.*?)\\\",/,1]
      end

      if script.match(/\"1280\"/)
        hash = script.scan(/\"thumbs\":{(.*)}/).to_s
        image_url = hash[/\\\"1280\\\":\\\"(.*?)\\\",/,1]
      end

      data = { :direct_link => direct_link, :image_url => image_url}
    end
  end
end