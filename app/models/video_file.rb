require 'video_parser'
require 'viddl-rb'

class VideoFile < ActiveRecord::Base
  after_create :initialize_source
  # scope :search_by_title, lambda { |title| where('title LIKE ?', "%#{title}") }
  scope :search_by_query, lambda { |query| where(query) }
  # scope :search_by_title, ->(title, description) { where('title LIKE ? OR description LIKE ?', "%#{title}%", "%#{description}")}
  belongs_to :user
  # after_create :save_file


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

  # def save_file
  #   if self.youtube
  #     url = ViddlRb.get_urls(self.url).first
  #     puts "DIRECT URL", url
  #     code = self.url.slice(/(\w+)$/)
  #     puts code
  #     code += 'youtube'
  #   end

  #   if self.vimeo
  #     code = self.url.slice(/(\d+)$/)
  #     code += 'vimeo'
  #   end

  #   if self.vk?
  #     code = self.url.slice(/([\d|_]+)$/)
  #     code += 'vk'
  #   end

  #   self.src_url = url
  #   self.local_url = "/#{code}.mp4"
  #   self.save
  #   puts "#{Rails.root.to_s}/public/#{code}.mp4"
  #   f = File.open("#{Rails.root.to_s}/public/#{code}.mp4", 'wb')
  #   f << open(url).read
  #   f.close
  # end

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
