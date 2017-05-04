class CreateCharities < ActiveRecord::Migration[5.0]
  def change
    create_table :charities do |t|
      t.integer :ein
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :category
      t.string :name
      t.string :url
      t.string :mission_statement
      t.integer :token_amount
      t.string :active?
      t.date :time_started

      t.timestamps
    end
  end
end
