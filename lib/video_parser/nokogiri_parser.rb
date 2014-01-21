require 'nokogiri'
require 'open-uri'
require 'open_uri_redirections'

module VideoParser
  class NokogiriParser
    def self.get_doc url
      html = open(url, :allow_redirections => :all)
      doc = Nokogiri::HTML(html.read)
      doc.encoding = 'utf-8'
      return doc
    end
  end
end