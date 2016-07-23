class AddQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.text :question
      t.datetime :created_at
      t.references :user_id
      t.references :drake_tip_id
    end
  end
end
