require 'nokogiri'
require 'open-uri'

module VideoParser
  class NokogiriParser
    def self.get_doc url
      html = open(url)
      doc = Nokogiri::HTML(html.read)
      doc.encoding = 'utf-8'
      return doc
    end
  end
end