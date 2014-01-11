require 'nokogiri'
require 'open-uri'

module VideoParser
  def self.parse_video_params url
    doc = Nokogiri::HTML(open(url))
    if url.match(/youtube/)
      title = doc.at_css('h1 span').content.gsub(/\s/, "")
      description = doc.at_xpath("//p[@id='eow-description']").content
    elsif url.match(/vimeo/)
      title = doc.at_css('h1').content
      if doc.at_css('div.description.read_more.collapsed')
        description = doc.at_css('div.description.read_more.collapsed > p.first').content
      else
        description = doc.at_css('div.description > p.first').content
      end
    end
    data = {:title => title, :description => description}
  end
end