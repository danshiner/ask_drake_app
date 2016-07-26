# IMPROVE regex phone number, could be stronger!!

class User < ActiveRecord::Base

@@CREDITS = 3

  has_many :drake_tips

  validates :phone_number,
    presence: { message: "Phone number required." },
    format: { with: /1\d{10}/, message: "Phone number not formatted correctly - must be 1##########" },
    uniqueness: true

  after_initialize :set_defaults

  def self.new_user?(phone_number)
  	User.where(phone_number: phone_number)
  end

  def set_defaults
    if self.new_record?
      self.credits = @@CREDITS
      self.has_received_rejection_message = false
    end
  end

  def remove_credits
    self.credits -= 1
    self.save
  end

end
