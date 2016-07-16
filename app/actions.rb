# Homepage (Root path)

get '/' do
end

post '/receive_sms' do

  @user_question = params[:Body]
  @phone_number = params[:From]

  def drakify(user, question)
    draketip = DrakeTip.new

    # Process DrakeTip: look up keyword, match keyword to lyric, render image
    keyword = draketip.determine_keywords(@user_question)
    lyric = draketip.get_lyric(keyword)
    image = draketip.image_render(lyric.lyric)

    # Define attributes of the newly created DrakeTip and save
    draketip.user_id = user.id
    draketip.lyric_id = lyric.id
    draketip.img_url = "/assets/draketips/draketip_#{draketip.id}"
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
      redirect "/send_sms?draketip=#{draketip.id}"
    else
      "Have to build rejection method"
    end
  else
    # binding.pry
    @new_user = User.create!(phone_number: @phone_number)
    draketip = drakify(@new_user, @user_question)
    draketip.save!
    # post_request

    #Typhoeus.post("/send_sms", params: { draketip: "#{draketip.id}"})
    #Typhoeus.get("/send_sms")

    redirect "/send_sms?draketip=#{draketip.id}"
  end

end

# get '/send_sms' do
#   puts "send is working"
# end

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
    from: "+16477223749", #can you change this?
    #media_url: "https://hotlineping.herokuapp.com/#{draketip_url}",
    body: "Hotling Ping:"
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
