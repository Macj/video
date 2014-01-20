require 'nokogiri_parser'

module VideoParser
  class Youtube
    def self.get_link url
      doc = NokogiriParser.get_doc(url)
      title = doc.at_css('title').content
      description = doc.at_xpath("//p[@id='eow-description']").content
      direct_link = url
      data = { :title => title, :description => description, :link => direct_link }
    end
  end
end