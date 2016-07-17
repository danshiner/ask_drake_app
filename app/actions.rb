# Homepage (Root path)

get '/' do
  erb :index
end

# Twilio posts to /receive_sms when it receives text at 647-277-DRIZ
post '/receive_sms' do

  @user_question = params[:Body]
  @phone_number = params[:From]

  def drakify(user, question)
    draketip = DrakeTip.new

    # Note: the order below is necessary because image render needs user_id and lyric_id in place to store image name.

    # Attach users foreign key
    draketip.user_id = user.id

    # Create lyric foreign key: determine keyword, look up lyric, attach lyrics foreign key
    keyword = draketip.determine_keywords(@user_question)
    lyric = draketip.get_lyric(keyword)
    draketip.lyric_id = lyric.id

    # Render image, store url
    image = draketip.image_render(lyric.lyric)
    draketip.img_url = "https://hotlineping.herokuapp.com/draketips/draketip_#{draketip.user_id}_#{draketip.lyric_id}.png"

    # Return draketip
    draketip
  end

  # Checks if the user exists; if so, stores in @user
  @user = User.where(phone_number: @phone_number)[0]
  if @user
    if @user.credits > 0
      draketip = drakify(@user, @user_question)
      draketip.save!
      # post_request(draketip)
      #Typhoeus.post("/send_sms", params: { draketip: "#{draketip.id}"})
      redirect to("/send_sms?draketip=#{draketip.id}")
    else
      "Have to build rejection method"
    end
  else
    @new_user = User.create!(phone_number: @phone_number)
    draketip = drakify(@new_user, @user_question)
    draketip.save!
    redirect to("/send_sms?draketip=#{draketip.id}")
  end

end

get '/send_sms' do
  @draketip = DrakeTip.find(params["draketip"])
  @recipient = @draketip.user
  to = @recipient.phone_number
  draketip_url = @draketip.img_url
  #message = params["body"]

  account_sid = 'AC6533ddc2b095658337840937b068c062'
  auth_token = '6a02e4987794c0ac52e40b35e1bf699a'

  client = Twilio::REST::Client.new(
    account_sid,
    auth_token
  )

  client.messages.create(
    to: to,
    from: "+1647722DRIZ", #can you change this?
    #media_url: "https://hotlineping.herokuapp.com/#{draketip_url}",
    body: "Hotling Ping:",
    media_url: @draketip.img_url
  )

end

#def post_request(draketip)

  # HTTParty.post("/",
  #   {
  #     :body => { "amount" => "0.25", "platform" => "gittip", "username" => "whit537" }.to_json,
  #     :basic_auth => { :username => api_key },
  #     :headers => { 'Content-Type' => 'application/json' }
  #    })

  # request = Typhoeus::Request.new(
  #   "/send_sms",
  #   method: :post,
  #   # body: "this is a request body",
  #   params: { draketip: "#{draketip.id}" },
  #   # headers: { Accept: "text/html" }
  # )
  # request.run
#end
