
# Thread.new do # trivial example work thread
#
#   verbose
#
#   use_streaming
#
#   home_timeline do |tweet|
#       # check if tweet is a mention of the bot
#       next if tweet.text !~ /@647hotlineping/i
#
#       # it is, do some work!
#       # puts Dir.pwd
#   #    reply "#USER#", tweet, {media: File.open("../public/draketips/draketip_#{100000}.png")}
#       #reply "#USER#", tweet, {media: "https://hotlineping.herokuapp.com/draketips/draketip_100071.png"}
#
#       # replies do
#         client.update_with_media "#USER#", File.open("./public/draketips/draketip_medium.png"), in_reply_to_status_id:tweet.id
#         #client.update_with_media "hello!", File.open(path_to_image), in_reply_to_status_id:tweet.id
#       # end
#
#   end


# Homepage (Root path)

get '/' do
  erb :index
end


# Twilio posts to /receive_sms when it receives text at 647-277-DRIZ
post '/receive_sms' do #Change to receive question for production

  # Receive input from user
  @incoming_question = params[:Body]
  @identifier = params[:From]

  # Based on platform, checks if user exists; if yes, stores in @user; if not, creates a new user.
  @user = Sender.set_user(@identifier, :twilio)

  # Store question in the database
  @question = Question.create(question: @incoming_question, user_id: @user.id)

  # Check if the user has sufficient credits; if yes create and send a draketip, if not, save question but do not send draketip.
  if Sender.user_meets_criteria?(@user)

    # Create the draketip
    @draketip = DrakeTip.make(@user, @question.question)

    # Store the question to the database
    @question.drake_tip_id = @draketip.id
    @question.save

    # Remove a credit from the user
    @user.remove_credits

    # Send the message
    puts @draketip.lyric.lyric
    # account_sid = 'AC6533ddc2b095658337840937b068c062'
    # auth_token = '6a02e4987794c0ac52e40b35e1bf699a'
    # client = Twilio::REST::Client.new(account_sid, auth_token)
    # client.messages.create(
    #   to: @user.phone_number,
    #   from: "+1647722DRIZ",
    #   media_url: @draketip.img_url
    # )

  # If insufficient credits, reject.
  else
    Sender.reject(@user)
  end

end

# post '/send_sms' do # Change to get when working with postman
#   @draketip = DrakeTip.find(params["draketip"])
#   @recipient = @draketip.user
#   to = @recipient.phone_number
#   draketip_url = @draketip.img_url
#
#   account_sid = 'AC6533ddc2b095658337840937b068c062'
#   auth_token = '6a02e4987794c0ac52e40b35e1bf699a'
#
#   client = Twilio::REST::Client.new(
#     account_sid,
#     auth_token
#   )
#
#   client.messages.create(
#     to: to,
#     from: "+1647722DRIZ",
#     media_url: @draketip.img_url
#   )
#
# end
