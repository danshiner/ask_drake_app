class DrakeTip < ActiveRecord::Base

  belongs_to :user
  belongs_to :lyric

  validates :user_id, :lyric_id, 
    presence: true,
    message: "foreign keys required"

  def parse
  end

  # Determine advice
  def lookup
  end

  # Turn into image
  def render
  end

end





    