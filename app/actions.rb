# Homepage (Root path)

get '/' do
  erb :index
end

# Twilio posts to /receive_sms when it receives text at 647-277-DRIZ
post '/receive_sms' do #Change to receive question for production

  # Receive input from user
  @incoming_question = params[:Body]
  @identifier = params[:From]

  # Create a new advice request
  @advice_request = AdviceRequest.new(@incoming_question, @identifier, :twilio)

  # Check if the user meets criteria for response; if yes respond, if not, reject.
  @advice_request.user_meets_criteria? ? Sender.respond(@advice_request) : Sender.reject(@advice_request)

end
