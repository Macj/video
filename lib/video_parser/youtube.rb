require 'video_parser/nokogiri_parser'

module VideoParser
  class Youtube
    def self.get_link url
      doc = NokogiriParser.get_doc(url)
      title = doc.at_css('title').content
      description = doc.at_xpath("//p[@id='eow-description']").content
      data = { :title => title, :description => description }
    end
  end
end