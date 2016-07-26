# Homepage (Root path)

get '/' do
  erb :index
end

# Twilio posts to /receive_sms when it receives text at 647-277-DRIZ
post '/receive_sms' do #Change to receive question for production

  # Receive input from user
  @incoming_question = params[:Body]
  @identifier = params[:From]

  # Set the user
  @user = User.set_user(@identifier, :twilio)

  # Create a new advice request
  @question = Question.create(question: @incoming_question, user_id: @user.id)

  # Check if the user meets criteria for response; if yes respond, if not, reject.
  @question.user_meets_criteria? ? Sender.reply(@question) : Sender.reject(@question)

end
