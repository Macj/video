require 'video_parser'

class VideoFile < ActiveRecord::Base
  after_create :initialize_source
  scope :search_by_title, lambda { |title| where('title LIKE ?', "%#{title}%") }

  def youtube
    self.url.match(/youtube/) and self.url.match(/watch/)
  end

  def vimeo
    self.url.match(/vimeo/)
  end

  private
    def initialize_source
      url = self.url
      if self.youtube
        code = url.sub /^.+\=/, ''
        self.update_attribute :code, code
      elsif self.vimeo
        code = url.sub /^.+\//, ''
        self.update_attribute :code, code
      end
    end
end
