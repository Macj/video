class VideoFilesController < ApplicationController
  before_action :set_video_file, only: [:show, :edit, :update]

  def index
    @video_files = VideoFile.all
  end

  def new
    @video_file = VideoFile.new
  end

  def create
    @video_file = VideoFile.new(video_file_params)

    if @video_file.save
      flash[:notice] = "Видео успешно загрузилось."
      redirect_to edit_video_file_path(@video_file)
    else
      flash[:error] = "Видео не было загружено. Попробуйте ещё раз."
      render :new
    end
  end

  def update
    if @video_file.update_attributes(video_file_params_edited)
      flash[:notice] = "Видео успешно сохранено."
      redirect_to video_files_path
    else
      flash[:error] = "Видео не было сохранено. Попробуйте ещё раз."
      render :edit
    end
  end

  private
    def set_video_file
      @video_file = VideoFile.find(params[:id])
    end

    def video_file_params
      params.require(:video_file).permit(:url)
    end

    def video_file_params_edited
      params.require(:video_file).permit(:title, :description)
    end
end