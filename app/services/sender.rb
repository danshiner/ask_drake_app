class Sender

  class << self

    def reply(question)
      # Answer the question
      @draketip = question.answer

      # Send the message, based on the platform of the advice request

      case question.user.platform
      when :twilio
        puts @draketip.lyric.lyric
        # account_sid = 'AC6533ddc2b095658337840937b068c062'
        # auth_token = '6a02e4987794c0ac52e40b35e1bf699a'
        # client = Twilio::REST::Client.new(account_sid, auth_token)
        # client.messages.create(
        #   to: advice_request.user.phone_number,
        #   from: "+1647722DRIZ",
        #   media_url: @draketip.img_url
        # )
      when :twitter
        message = replace_variables("#USER#", tweet)
        client.update_with_media message, File.open("./public/draketips/draketip_medium.png"), in_reply_to_status_id:tweet.id
      end
    end

    def reject(question)
      puts "User #{question.user.id} does not have sufficient credits to receive a draketip."
    end

    # Determine if the user meets the criteria to receive a draketip. As of 07/2016, this is based on having a positive number of credits.
    def user_meets_criteria?(user)
      user.credits > 0
    end

  end

end
