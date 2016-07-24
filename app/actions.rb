
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
post '/receive_sms' do

  @user_question = params[:Body]
  @phone_number = params[:From]

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

  # Checks if the user exists; if so, stores in @user
  @user = User.where(phone_number: @phone_number)[0] || User.create(phone_number: @phone_number)

    if @user.credits > 0
      @draketip = drakify(@user, @user_question)
      @draketip.save!
      Question.create(question: @user_question, user_id: @user.id, drake_tip_id: @draketip.id)
      @user.credits -= 1
      @user.save
      redirect to("/send_sms?draketip=#{@draketip.id}")
    else
      # If insufficient credits, store message to the database but do not send a DrakeTip.
      Question.create(question: @user_question, user_id: @user.id, drake_tip_id: nil)
      puts "User #{@user.id} does not have sufficient credits to receive a draketip."
    end

end

post '/send_sms' do # Change to get when working with postman
  @draketip = DrakeTip.find(params["draketip"])
  @recipient = @draketip.user
  to = @recipient.phone_number
  draketip_url = @draketip.img_url

  account_sid = 'AC6533ddc2b095658337840937b068c062'
  auth_token = '6a02e4987794c0ac52e40b35e1bf699a'

  client = Twilio::REST::Client.new(
    account_sid,
    auth_token
  )

  client.messages.create(
    to: to,
    from: "+1647722DRIZ",
    media_url: @draketip.img_url
  )

end
