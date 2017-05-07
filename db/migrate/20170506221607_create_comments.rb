class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.integer :user_id
      t.integer :charity_id
      t.string :title
      t.text :content

      t.timestamps
    end
  end
end
