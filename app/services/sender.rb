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
        if (@draketip.id % 100000 == 0)
          client.messages.create(
            to: question.user.phone_number,
            from: "+1647722DRIZ",
            # Careful with commas!
            # body: "#{@draketip.lyric.lyric} \n\nhotline ping \u260E \nping no #{100000+@draketip.id} \n#{question.user.credits} pings remaining"
            body: "#{question.user.credits} pings remaining",
            media_url: @draketip.img_url
          )
        else
          client.messages.create(
            to: question.user.phone_number,
            from: "+1647722DRIZ",
            # Careful with commas!
            body: "#{@draketip.lyric.lyric} \n\nhotline ping \u260E\n#{question.user.credits} pings remaining \n647hotlineping.com"
            # body: "#{question.user.credits} pings remaining",
            # media_url: @draketip.img_url
          )
        end
      when :twitter
        # message = replace_variables("#USER#", tweet)
        # client.update_with_media message, File.open("./public/draketips/draketip_#{100000+@draketip.id}.png"), in_reply_to_status_id:tweet.id
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
