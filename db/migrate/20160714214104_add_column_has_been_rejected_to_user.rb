class AddColumnHasBeenRejectedToUser < ActiveRecord::Migration
  def change
    add_column(:users, :has_received_rejection_message, :boolean)
  end
end
