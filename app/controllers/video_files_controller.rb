require 'video_parser/vimeo'
require 'video_parser'

class VideoFilesController < ApplicationController
  before_action :set_video_file, only: [:show, :edit, :update]
  before_action :autorize_user, only: [:my_videos, :create, :edit]

  def index
    @query = params[:query]
    if @query and @query != ""
      @video_files = VideoFile.search_query(@query).order('created_at DESC').page(params[:page])
    elsif @query and @query == ""
      flash[:error] = "Введите запрос."
      redirect_to root_path
    else
      @video_files = VideoFile.order('created_at DESC').page(params[:page]).per(5)
    end
  end

  def my_videos
    @video_files = VideoFile.where(:user_id => current_user.id).limit(20)
  end

  def new
    @video_file = VideoFile.new
  end

  def create
    @video_file = VideoFile.new(video_file_params)

    if @video_file.url.match(/vimeo.com/) and !@video_file.url.include?('https')
      @video_file.url = @video_file.url.insert(4, 's')
    elsif @video_file.url.match(/vk/) and current_user.provider != "vkontakte"
      flash[:error] = "Вы должны авторизоваться Вконтакте."
      redirect_to sign_in_path
    elsif @video_file.save
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
    @image = data[:image_url]
    @player = data[:player]
    if @video_file.vk?
      @video_file.update_attributes(:title => @title, :description => @description, :player => @player, :image_url => @image)
    else
      @video_file.update_attributes(:title => @title, :description => @description)
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
      params.require(:video_file).permit(:url, :user_id)
    end

    def video_file_params_edited
      params.require(:video_file).permit(:title, :description, :player)
    end

    def autorize_user
      if current_user == nil
        puts current_user.inspect
        flash[:error] = "Нужна авторизация."
        redirect_to sign_in_path
      end
    end
end