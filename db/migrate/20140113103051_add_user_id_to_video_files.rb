class AddUserIdToVideoFiles < ActiveRecord::Migration
  def change
    add_column :video_files, :user_id, :integer
  end
end
