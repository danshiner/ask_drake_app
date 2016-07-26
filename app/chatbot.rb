require 'rubygems'
require 'chatterbot/dsl'
require 'net/http'

verbose

use_streaming

home_timeline do |tweet|
  # check if tweet is a mention of the bot
  next if tweet.text !~ /@647hotlineping/i

  # Get the name of the asker
  @identifier = tweet_user(tweet)
  @incoming_question = tweet.text

  puts asker
  puts question

  # Set the user
  @user = User.set_user(@identifier, :twilio)

  # Create a new advice request
  @question = Question.create(question: @incoming_question, user_id: @user.id)

  # Check if the user meets criteria for response; if yes respond, if not, reject.
  @question.user_meets_criteria? ? Sender.reply(@question) : Sender.reject(@question)

  # THE BELOW WORKS BUT HOPING I CAN REMOVE IT AND JUST USE THE ABOVE:
  # # Get the asker's twitter username and put it in the reply
  # message = replace_variables("#USER#", tweet)
  #
  # # Post the message with an image
  # client.update_with_media message, File.open("./public/draketips/draketip_medium.png"), in_reply_to_status_id:tweet.id

  # Post request info: http://travisonrails.com/2007/11/07/http-get-and-post-requests-with-ruby

  # Note: new (unreleased) behaviour will allow easier media posting: this is in the github but not posted.
  # reply "#USER#", tweet, {media: File.open("../public/draketips/draketip_#{100000}.png")}

end
