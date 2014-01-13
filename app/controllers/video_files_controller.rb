class VideoFilesController < ApplicationController
  before_action :set_video_file, only: [:show, :edit, :update]

  def index
    @query = params[:query]
    if @query and @query != ""
      @video_files = VideoFile.search_query @query
    else
      @video_files = VideoFile.all
    end
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

  def edit
    data = VideoParser.parse_video_params(@video_file.url, session[:vk_token])
    @title = data[:title]
    @description = data[:description]
    @video_file.update_attributes(:title => @title, :description => @description)
    if @video_file.vk?
      @player = data[:player]
      @video_file.update_attributes(:title => @title, :description => @description, :player => @player)
    end
  end

  def update
    if @video_file.update_attributes(video_file_params_edited)
      flash[:notice] = "Видео успешно сохранено."
      redirect_to video_file_path(@video_file)
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
      params.require(:video_file).permit(:title, :description, :player)
    end
end