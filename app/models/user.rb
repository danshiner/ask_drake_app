# IMPROVE regex phone number, could be stronger!!

class User < ActiveRecord::Base

@@CREDITS = 3

  has_many :drake_tips

  validates :phone_number,
    presence: { message: "Phone number required." },
    format: { with: /1\d{10}/, message: "Phone number not formatted correctly - must be 1##########" },
    uniqueness: true

  after_initialize :set_defaults

  # Determines if the user exists or not, based on the unique identifier. If yes, return the user; if no, create a new user with the identifier.
  # Identifier is the unique identifier of the user. Platform is the source. Could technically determine the platform from the identifier, but because international phone numbers can come into so many different forms, passing an explicit platform parameter is less error prone.
  def self.set_user(identifier, platform)
    case platform
    when :twilio
      @user = User.where(phone_number: identifier)[0] || User.create(phone_number: identifier)
    when :twitter
      @user = User.where(twitter_username: identifier)[0] || User.create(twitter_username: identifier)
    end
  end

  def platform
    if self.phone_number != nil
      :twilio
    elsif self.twitter_username != nil
      :twitter
    end 
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
