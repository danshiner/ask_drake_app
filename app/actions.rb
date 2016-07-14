# Homepage (Root path)
get '/' do
  erb :index
end


post '/receive_sms' do
  content_type 'text/xml' #Note: may need to change this for MMS

  response = Twilio::TwiML::Response.new do |r|
  	r.Message 'Thanks for messaging Drakebot.'
  end

  response.to_xml

end

post '/send_sms' do
	to = params["to"] #DAN YOU CREATE THESE
	message = params["body"] #DAN YOU CREATE THESE

	client = Twilio::REST::Client.new(
		ENV["TWILIO_ACCOUNT_SID"],
		ENV["TWILIO_AUTH_TOKEN"]

	)

	client.messages.create(
		to: to,
		from: "+16477223749",
		message: message
		)

end