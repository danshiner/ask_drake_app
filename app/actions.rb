# helpers do
#
#   # Gets tune from params[:id] or redirects to tune list
#   def get_tune
#     @tune = Tune.find_by(id: params[:id])
#     redirect '/tunes' unless @tune
#   end
#
# end


# Homepage (Root path)

get '/' do
end

# ngrok is only needed for /receive_sms, because it looks for the view. The rest can be done locally

post '/receive_sms' do

  @user_question = params[:Body]
  @phone_number = params[:From]

  # Evaluate User

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
    draketip.save!
  end

  # Checks if the user exists; if so, stores in @user
  @user = User.where(phone_number: @phone_number)[0]
  if @user
    @user.credits > 0 ? drakify(@user, @user_question) : "Have to build rejection method"
  else
    @new_user = User.create(phone_number: @phone_number)
    drakify(@new_user, @user_question)
  end

end

# Note: the following works

=begin
post '/receive_sms' do
  body = params[:Body]
  content_type 'text/xml' #Note: may need to change this for MMS

  response = Twilio::TwiML::Response.new do |r|
  	r.Message "Thanks for messaging Drakebot, #{body}."
  end

  response.to_xml

end
=end

=begin
post '/send_sms' do
  to = params["to"] #DAN YOU CREATE THESE
  message = params["body"] #DAN YOU CREATE THESE

  account_sid = 'AC6533ddc2b095658337840937b068c062'
  auth_token = '6a02e4987794c0ac52e40b35e1bf699a'

  client = Twilio::REST::Client.new(
    account_sid,
    auth_token
  )

  client.messages.create(
    to: to,
    from: "+16477223749",
    body: message
  )

end
=end
