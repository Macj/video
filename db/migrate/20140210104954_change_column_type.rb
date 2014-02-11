class ChangeColumnType < ActiveRecord::Migration
  def change
    change_column :video_files, :description, :text
  end
end
