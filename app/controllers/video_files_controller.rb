class VideoFilesController < ApplicationController
  before_action :set_video_file, only: [:show]

  def index
    @video_files = VideoFile.all
  end

  private
    def set_video_file
      @video_file = VideoFile.find(params[:id])
    end

    def currency_params
      params.require(:video_file).permit(:title, :description, :url)
    end
end