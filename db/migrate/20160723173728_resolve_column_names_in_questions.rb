class ResolveColumnNamesInQuestions < ActiveRecord::Migration
  def change
    rename_column :questions, :user_id_id, :user_id
    rename_column :questions, :drake_tip_id_id, :drake_tip_id
  end
end
