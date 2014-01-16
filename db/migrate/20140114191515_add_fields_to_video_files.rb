class AddFieldsToVideoFiles < ActiveRecord::Migration
  def change
    add_column :video_files, :local_url, :string
    add_column :video_files, :src_url, :string
  end
end
