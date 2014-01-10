class CreateVideoFiles < ActiveRecord::Migration
  def change
    create_table :video_files do |t|
      t.string :title
      t.string :description
      t.string :url

      t.timestamps
    end
  end
end
