class Sender

  class << self

    # Determines if the user exists or not, based on the unique identifier. If yes, return the user; if no, create a new user with the identifier.
    # Identifier is the unique identifier of the user. Platform is the source. Could technically determine the platform from the identifier, but because international phone numbers can come into so many different forms, passing an explicit platform parameter is less error prone.
    def set_user(identifier, platform)
      case platform
      when :twilio
        @user = User.where(phone_number: identifier)[0] || User.create(phone_number: identifier)
      when :twitter
        @user = User.where(twitter_username: identifier)[0] || User.create(twitter_username: identifier)
      end
    end

    # Determine if the user meets the criteria to receive a draketip. As of 07/2016, this is based on having a positive number of credits.
    def user_meets_criteria?(user)
      user.credits > 0
    end

    def reject(user)
      puts "User #{@user.id} does not have sufficient credits to receive a draketip."
    end

  end

end
