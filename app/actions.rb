require '../config/environment' #TESTING ONLY, DELEE AFTERWARDS, SUPERFLUOUS 

# Homepage (Root path)
get '/' do
  @message = Message.new
  erb :index
end

# ngrok is only needed for /receive_sms, because it looks for the view. The rest can be done locally

post '/receive_sms' do

  body = params[:Body]
  phone_number = params[:From]

  # Evaluate User

  @user = User.where(phone_number: phone_number)

  if @user
    @user.credits > 0 ? "Drakify him" : @user.reject
  else
    @user = User.new
    puts "Drakify him"
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