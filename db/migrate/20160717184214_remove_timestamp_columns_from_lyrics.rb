class RemoveTimestampColumnsFromLyrics < ActiveRecord::Migration
  def change
    remove_column :lyrics, :created_at
    remove_column :lyrics, :updated_at
  end
end
