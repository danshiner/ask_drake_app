require '../../config/environment' #TESTING ONLY, DELEE AFTERWARDS, SUPERFLUOUS

class User < ActiveRecord::Base

  has_many :drake_tips

  validates :phone_number,
    presence: { message: "Phone number required." },
    format: { with: /\+1[2-9]{2}\d{8}/, message: "Phone number not formatted correctly - must be +1##########" },
    uniqueness: true

  def self.new_user?(phone_number)
  	User.where(phone_number: phone_number)
  end

  def reject
  	self.credits > 0
  end

end