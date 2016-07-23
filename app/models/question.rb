class Question < ActiveRecord::Base

  belongs_to :user
  belongs_to :drake_tip

  validates :user_id,
    presence: { message: "User_id required" }

  # def initialize(question, user_id, drake_tip_id)
  #   self.question = question
  #   self.user_id = user_id
  #   self.drake_tip_id = drake_tip_id
  # end

  # before_save :truncate_columns     ADD LATER IF YOU HAVE TIME!

  # def truncate_col
  #   column_size = Question.columns_hash['question'].limit
  #   self.question = self.question.truncate(column_size)
  # end

end
