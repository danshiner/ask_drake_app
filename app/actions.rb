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