require 'rubygems'
require 'chatterbot/dsl'
require 'pry'

verbose

use_streaming

replies do |tweet|
 # Any time you put the #USER# token in a tweet, Chatterbot will
 # replace it with the handle of the user you are interacting with
 reply "#USER#, you are very kind to say that!", tweet
end
