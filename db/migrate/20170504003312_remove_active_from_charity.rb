class RemoveActiveFromCharity < ActiveRecord::Migration[5.0]
  def change
    remove_column :charities, :active?, :string
  end
end
