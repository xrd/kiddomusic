class AddSongThumbnail < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.timestamps
      t.string :thumbnail
      t.string :title
      t.string :name
      t.string :src
      t.string :path
    end
  end
end
