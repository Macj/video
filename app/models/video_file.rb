class VideoFile < ActiveRecord::Base
  scope :search_by_query, lambda { |query| where(query) }
  belongs_to :user
  has_many :comments
  after_create :initialize_source
  validates_presence_of :url

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
        uri = URI.parse("http://vimeo.com/api/v2/video/#{self.player}.json")
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Get.new(uri.request_uri)
        response = http.request(request)
        data = ActiveSupport::JSON.decode(response.body)
        image_url = data[0]["thumbnail_large"]
        self.update_attribute :image_url, image_url
      end
    end
end
