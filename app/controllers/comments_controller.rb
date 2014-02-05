class CommentsController < ApplicationController
  def create
    @video_file = VideoFile.find(params[:video_file_id])
    @comment = @video_file.comments.create!(:body => params[:comment]["body"], :user_id => current_user.id)
    redirect_to @video_file
  end

  private
    def comment_params
      params.require(:comment).permit(:body, :video_file_id, :user_id)
    end
end