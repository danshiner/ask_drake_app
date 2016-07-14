class AddLyrics < ActiveRecord::Migration

  def change
  	create_table :lyrics do |t|
	  t.string :lyric
	  t.datetime :created_at
	  t.datetime :updated_at
    end
  end

end
