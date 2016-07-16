class ResolveColumnNamesInLyrics < ActiveRecord::Migration
  def change
    rename_column :drake_tips, :user_id_id, :user_id
    rename_column :drake_tips, :lyric_id_id, :lyric_id
  end
end
