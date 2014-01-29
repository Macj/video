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
      data = { :title => title, :description => description }
    end
  end
end