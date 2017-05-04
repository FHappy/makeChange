class CreateDonations < ActiveRecord::Migration[5.0]
  def change
    create_table :donations do |t|
      t.integer :user_id
      t.integer :charity_id
      t.integer :token_amount

      t.timestamps
    end
  end
end
