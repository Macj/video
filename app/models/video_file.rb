class VideoFile < ActiveRecord::Base
  scope :search_by_query, lambda { |query| where(query) }
  belongs_to :user
  after_create :initialize_source

  def youtube?
    self.url.match(/youtube/) and self.url.match(/watch/)
  end

  def vimeo?
    self.url.match(/vimeo.com/)
  end

  def vk?
    self.url.match(/vk/)
  end

  def self.search_query str
    str = '%' + str + '%'
    query = ["title LIKE ? OR description LIKE ?",str,str]
    self.search_by_query query
  end

  private
    def initialize_source
      url = self.url
      if self.youtube?
        player = url.sub /^.+\=/, ''
        self.update_attribute :player, player
      elsif self.vimeo?
        player = url.sub /^.+\//, ''
        self.update_attribute :player, player
      end
    end
end
