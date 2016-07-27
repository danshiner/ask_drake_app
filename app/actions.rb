# Twilio posts to /receive_sms when it receives text at 647-722-DRIZ
post '/receive_sms' do #Change to receive question for production

  # Receive input from user
  @identifier = params[:From]
  @incoming_question = params[:Body]

  # Set the user
  @user = User.set_user(@identifier, :twilio)

  # Create a new question
  @question = Question.create(question: @incoming_question, user_id: @user.id)

  # Check if the user meets criteria for response; if yes respond, if not, reject.
  Sender.user_meets_criteria?(@user) ? Sender.reply(@question) : Sender.reject(@question)

end
