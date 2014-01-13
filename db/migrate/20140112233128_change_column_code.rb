class ChangeColumnCode < ActiveRecord::Migration
  def change
    rename_column :video_files, :code, :player
  end
end
