class AddDrakeTips < ActiveRecord::Migration

  def change
    create_table :drake_tips do |t|
      t.references :user_id
      t.references :lyric_id
      t.datetime :created_at
    end
  end

end
