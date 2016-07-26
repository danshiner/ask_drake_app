class Question < ActiveRecord::Base

  belongs_to :user
  belongs_to :drake_tip

  validates :user_id,
    presence: { message: "User_id required" }

    

end
