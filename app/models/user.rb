class User < ActiveRecord::Base

  has_many :drake_tips

  validates :phone_number,
    presence: true, message: "Phone number required."
    format: { with: /\+1[2-9]{2}\d{8}/, message: "Phone number not formatted correctly - must be +1##########" }

end