class AdviceRequest

  def initialize(incoming_question, identifier, platform)
    @user = self.set_user(identifier, platform)
    @question = Question.create(question: incoming_question, user_id: @user.id)
  end

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
  def user_meets_criteria?
    @user.credits > 0
  end

  def fulfill
    # Create the draketip
    @draketip = DrakeTip.make(@user, @question.question)

    # Store the question to the database
    @question.drake_tip_id = @draketip.id
    @question.save

    # Remove a credit from the user
    @user.remove_credits

    # Return the draketip
    @draketip
  end

  def send
    case platform
    when :twilio
      # Send the message via twilio
      puts @draketip.lyric.lyric
      # account_sid = 'AC6533ddc2b095658337840937b068c062'
      # auth_token = '6a02e4987794c0ac52e40b35e1bf699a'
      # client = Twilio::REST::Client.new(account_sid, auth_token)
      # client.messages.create(
      #   to: @user.phone_number,
      #   from: "+1647722DRIZ",
      #   media_url: @draketip.img_url
      # )
    when :twitter
      client.update_with_media message, File.open("./public/draketips/draketip_medium.png"), in_reply_to_status_id:tweet.id
  end

  def reject
    puts "User #{@user.id} does not have sufficient credits to receive a draketip."
  end

end
