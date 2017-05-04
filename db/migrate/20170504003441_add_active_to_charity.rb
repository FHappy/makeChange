class AddActiveToCharity < ActiveRecord::Migration[5.0]
  def change
    add_column :charities, :is_active?, :boolean, default: true
  end
end
