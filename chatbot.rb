# Note: chatbot.rb and chatbot.yml MUST BE IN ROOT (or same folder as config.ru), otherwise links to image render assets break.

require ::File.expand_path('../config/environment',  __FILE__)

set :app_file, __FILE__

#
require 'rubygems'
require 'chatterbot/dsl'
require 'net/http'

verbose

use_streaming

home_timeline do |tweet|
  # check if tweet is a mention of the bot
  next if tweet.text !~ /@647hotlineping/i
  binding.pry
  @tweet = tweet

  # Get the name of the asker
  @identifier = tweet_user(tweet)
  @incoming_question = tweet.text

  puts @identifier
  puts @incoming_question

  # Set the user
  @user = User.set_user(@identifier, :twitter)

  # Create a new advice request
  @question = Question.create(question: @incoming_question, user_id: @user.id)

  # Check if the user meets criteria for response; if yes respond, if not, reject.
  Sender.user_meets_criteria?(@user) ? Sender.reply(@question, client, @tweet) : Sender.reject(@question)

  # Note: new (unreleased) behaviour will allow easier media posting: this is in the github but not posted.
  # reply "#USER#", tweet, {media: File.open("../public/draketips/draketip_#{100000}.png")}

end
