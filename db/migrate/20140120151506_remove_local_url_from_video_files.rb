class RemoveLocalUrlFromVideoFiles < ActiveRecord::Migration
  def change
    remove_column :video_files, :local_url
  end
end
