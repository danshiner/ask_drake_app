class Lyric < ActiveRecord::Base

  has_many :draketips

  validates :lyric,
    presence: { message: "Lyric required." },
    length: { minimum: 5, maximum: 255, message: "Lyric must be between 5 and 255 characters." }

end