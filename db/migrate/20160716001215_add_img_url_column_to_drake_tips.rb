class AddImgUrlColumnToDrakeTips < ActiveRecord::Migration
  def change
    add_column(:drake_tips, :img_url, :string)
  end
end
