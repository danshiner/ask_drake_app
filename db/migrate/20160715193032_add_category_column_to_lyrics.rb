class AddCategoryColumnToLyrics < ActiveRecord::Migration
  def change
  	add_column(:lyrics, :category, :string)
  end
end
