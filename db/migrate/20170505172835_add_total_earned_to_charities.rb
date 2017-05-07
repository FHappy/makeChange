class AddTotalEarnedToCharities < ActiveRecord::Migration[5.0]
  def change
    add_column :charities, :total_earned, :integer, default: 0
  end
end
