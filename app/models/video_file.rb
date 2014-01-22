class VideoFile < ActiveRecord::Base
  scope :search_by_query, lambda { |query| where(query) }
  belongs_to :user

  def youtube?
    self.url.match(/youtube/) and self.url.match(/watch/)
  end

  def vimeo?
    self.url.match(/vimeo.com/)
  end

  def vk?
    self.url.match(/vk/)
  end

  def vk_and_vimeo?
    self.url.match(/vk/) and self.player.match(/vimeo.com/)
  end

  def self.search_query str
    str = '%' + str + '%'
    query = ["title LIKE ? OR description LIKE ?",str,str]
    self.search_by_query query
  end
end
