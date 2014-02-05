class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :video_file
  validates_presence_of :body
end
