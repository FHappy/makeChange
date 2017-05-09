class ChangeUserTokenDefault < ActiveRecord::Migration[5.0]
  def change
  	change_column :users, :token_amount, :integer, default: 0
  end
end
