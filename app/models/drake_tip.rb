require '../../config/environment' #TESTING ONLY, DELEE AFTERWARDS, SUPERFLUOUS

class DrakeTip < ActiveRecord::Base

  belongs_to :user
  belongs_to :lyric

  validates :user_id, :lyric_id, 
    presence: { message: "Foreign keys required" }

  def initialize

  end

  def parse
  end

  # Determine advice
  def lookup
  end

  # Turn into image
  def render
  end

end





    