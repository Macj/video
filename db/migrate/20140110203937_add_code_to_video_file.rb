class AddCodeToVideoFile < ActiveRecord::Migration
  def change
    add_column :video_files, :code, :string
  end
end
