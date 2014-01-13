require 'video_parser'

class VideoFile < ActiveRecord::Base
  after_create :initialize_source
  scope :search_by_title, lambda { |title| where('title LIKE ?', "%#{title}") }
  scope :search_by_query, lambda { |query| where(query) }
  # scope :search_by_title, ->(title, description) { where('title LIKE ? OR description LIKE ?', "%#{title}%", "%#{description}")}
  belongs_to :user


  def youtube
    self.url.match(/youtube/) and self.url.match(/watch/)
  end

  def vimeo
    self.url.match(/vimeo/)
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
      if self.youtube
        player = url.sub /^.+\=/, ''
        self.update_attribute :player, player
      elsif self.vimeo
        player = url.sub /^.+\//, ''
        self.update_attribute :player, player
      end
    end
end
