
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

  def drakify(user, question)
    draketip = DrakeTip.create

    # Attach users foreign key
    draketip.user_id = user.id

    # Create lyric foreign key: determine keyword, look up lyric, attach lyrics foreign key
    keyword = draketip.determine_keywords(question)
    lyric = draketip.get_lyric(keyword)
    draketip.lyric_id = lyric.id

    # Render image, store url
    image = draketip.image_render(lyric.lyric)
    draketip.img_url = "https://hotlineping.herokuapp.com/draketips/draketip_#{100000+draketip.id}.png"

    # Return draketip
    draketip
  end

  # Identify source
  def identify_source
    case params[:source]
    when "twitter"
      "twitter"
    when nil
      "twilio"
    end
  end

  # Receive input from user
  @user_question = params[:Body]
  @sender = params[:From]
  @platform = params[:Platform]
  # @phone_number = params[:From]

  # Based on platform, checks if user exists; if yes, stores in @user; if not, creates a new user
  case @platform
  when nil #Twilio does not send a params[:Platform], so this is for Twilio
    @user = User.where(phone_number: @sender)[0] || User.create(phone_number: @sender)
  when "twitter"
    @user = User.where(twitter_username: @sender)[0] || User.create(twitter_username: @sender)
  end

  # Check if the user has sufficient credits; if yes create and send a draketip, if not, save question but do not send draketip.
  if @user.credits > 0

    # Create the draketip
    @draketip = drakify(@user, @user_question)
    @draketip.save!

    # Store the question to the database
    Question.create(question: @user_question, user_id: @user.id, drake_tip_id: @draketip.id)

    # Remove a credit from the user
    @user.credits -= 1
    @user.save

    # Send the message; action is dependent on platform
    case @platform
    when nil #Twilio does not send a params[:Platform], so this is for Twilio
      puts @draketip.lyric.lyric
      # account_sid = 'AC6533ddc2b095658337840937b068c062'
      # auth_token = '6a02e4987794c0ac52e40b35e1bf699a'
      # client = Twilio::REST::Client.new(account_sid, auth_token)
      # client.messages.create(
      #   to: @user.phone_number,
      #   from: "+1647722DRIZ",
      #   media_url: @draketip.img_url
      # )

    when "twitter"
      file_location = @draketip.img_url.slice!("https://hotlineping.herokuapp.com/")
      client.update_with_media message, File.open("./public/#{file_location}"), in_reply_to_status_id:tweet.id
    end

  # If insufficient credits, save message to the database but do not send a DrakeTip.
  else
    Question.create(question: @user_question, user_id: @user.id, drake_tip_id: nil)
    puts "User #{@user.id} does not have sufficient credits to receive a draketip."
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
