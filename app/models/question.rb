class Question < ActiveRecord::Base

  belongs_to :user
  belongs_to :drake_tip

  validates :user_id,
    presence: { message: "User_id required" }

  def answer
    # Create the draketip
    
    draketip = DrakeTip.make(self.user, self.question)

    # Store the question to the database
    self.drake_tip_id = draketip.id
    self.save

    # Remove a credit from the user
    self.user.remove_credits

    # Return the draketip
    draketip
  end

end
