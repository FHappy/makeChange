class ChangeDefaultCharityTokenAmount < ActiveRecord::Migration[5.0]
  def change
    change_column :charities, :token_amount, :integer, default: 0
  end
end
