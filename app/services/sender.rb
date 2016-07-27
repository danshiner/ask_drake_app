class Sender

  class << self

    # Reply class, which produces and then sends the draketip. Takes an optional tweet class because to send over twitter must pass the tweet as well.
    def reply(question, client=nil, tweet=nil)
      # Answer the question
      @draketip = question.answer

      # Send the message, based on the platform of the advice request
      case question.user.platform
      when :twilio
        puts @draketip.lyric.lyric
        account_sid = 'AC6533ddc2b095658337840937b068c062'
        auth_token = '6a02e4987794c0ac52e40b35e1bf699a'
        client = Twilio::REST::Client.new(account_sid, auth_token)
        client.messages.create(
          to: question.user.phone_number,
          from: "+1647722DRIZ",
          body: "pings remaining: #{question.user.credits}",
          media_url: @draketip.img_url
        )
      when :twitter
        message = replace_variables("#USER#", tweet)
        client.update_with_media message, File.open("./public/draketips/draketip_#{100000+@draketip.id}.png"), in_reply_to_status_id:tweet.id
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
