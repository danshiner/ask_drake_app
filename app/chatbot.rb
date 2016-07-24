require 'rubygems'
require 'chatterbot/dsl'

verbose

use_streaming

home_timeline do |tweet|
  # check if tweet is a mention of the bot
  next if tweet.text !~ /@647hotlineping/i

  # Get the asker's twitter username and put it in the reply
  message = replace_variables("#USER#", tweet)

  # Post the message with an image
  client.update_with_media message, File.open("./public/draketips/draketip_medium.png"), in_reply_to_status_id:tweet.id

  # Note: new (unreleased) behaviour will allow easier media posting: this is in the github but not posted.
  # reply "#USER#", tweet, {media: File.open("../public/draketips/draketip_#{100000}.png")}

end
