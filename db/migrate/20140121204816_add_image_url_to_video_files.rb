class AddImageUrlToVideoFiles < ActiveRecord::Migration
  def change
    add_column :video_files, :image_url, :string
    rename_column :video_files, :src_url, :video_url
  end
end
