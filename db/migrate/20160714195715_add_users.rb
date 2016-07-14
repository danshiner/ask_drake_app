class AddUsers < ActiveRecord::Migration

  def change
    create_table :users do |t|
      t.string :phone_number
      t.integer :credits
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

end
