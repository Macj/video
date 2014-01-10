class VideoFile < ActiveRecord::Base
  after_create :initialize_source

  def youtube
    self.url.match(/youtube/) and self.url.match(/watch/)
  end

  def vimeo
    self.url.match(/vimeo/)
  end

  private
    def initialize_source
      if self.youtube
        code = link.sub /^.+\=/, ''
        self.update_attribute :code, code
      elsif self.vimeo
        code = link.sub /^.+\//, ''
        self.update_attribute :code, code
      end
    end
end
