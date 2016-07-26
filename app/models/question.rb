class Question < ActiveRecord::Base

  belongs_to :user
  belongs_to :drake_tip

  validates :user_id,
    presence: { message: "User_id required" }

  # Determine if the user meets the criteria to receive a draketip. As of 07/2016, this is based on having a positive number of credits.
  def user_meets_criteria?
    self.user.credits > 0
  end

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
